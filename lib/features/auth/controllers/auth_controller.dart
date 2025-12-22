import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum AuthStatus { unknown, authenticated, unauthenticated, loading }

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  bool _isDisposed = false;

  static const String _cachedUserKey = 'cached_user_data';

  AuthController() {
    _checkSession();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _checkSession() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _status = AuthStatus.loading;
      _safeNotify();
      await _fetchUserData(currentUser.uid);
    } else {
      await _loadCachedUser();
      if (_user == null) {
        _status = AuthStatus.unauthenticated;
        _safeNotify();
      }
    }
  }

  Future<void> _loadCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cachedUserKey);
      if (cached != null) {
        final data = jsonDecode(cached) as Map<String, dynamic>;
        _user = UserModel.fromMap(data);
        _isOffline = true;
        _status = AuthStatus.authenticated;
        _safeNotify();
      }
    } catch (e) {
      debugPrint('Error loading cached user: $e');
    }
  }

  Future<void> _cacheUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cachedUserKey, jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error caching user: $e');
    }
  }

  Future<void> _clearCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cachedUserKey);
    } catch (e) {
      debugPrint('Error clearing cached user: $e');
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _safeNotify();

    try {
      UserCredential cred = await _auth
          .signInWithEmailAndPassword(email: email.trim(), password: password)
          .timeout(const Duration(seconds: 15));

      bool dataFetched = await _fetchUserData(cred.user!.uid);
      if (!dataFetched) {
        await logout();
        return 'User data not found. Please contact HR support.';
      }

      _isOffline = false;
      return null;
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      _safeNotify();
      return _getAuthErrorMessage(e.code);
    } on SocketException {
      _status = AuthStatus.unauthenticated;
      _safeNotify();
      return 'No internet connection. Please check your network.';
    } on TimeoutException {
      _status = AuthStatus.unauthenticated;
      _safeNotify();
      return 'Connection timeout. Please try again.';
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _safeNotify();
      debugPrint('Login error: $e');
      return 'Login failed. Please try again.';
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled. Contact HR.';
      case 'too-many-requests':
        return 'Too many failed attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  Future<bool> _fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('employees')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (doc.exists) {
        _user = UserModel.fromSnapshot(doc);
        await _cacheUser(_user!);
        _status = AuthStatus.authenticated;
        _isOffline = false;
        _safeNotify();
        return true;
      } else {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _safeNotify();
        return false;
      }
    } on SocketException {
      await _loadCachedUser();
      return _user != null;
    } on TimeoutException {
      await _loadCachedUser();
      return _user != null;
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      await _loadCachedUser();
      return _user != null;
    }
  }

  Future<void> logout() async {
    _status = AuthStatus.loading;
    _safeNotify();

    try {
      await _auth.signOut();
      await _clearCachedUser();
    } catch (e) {
      debugPrint('Logout error: $e');
    }

    _user = null;
    _isOffline = false;
    _status = AuthStatus.unauthenticated;
    _safeNotify();
  }

  Future<void> refreshUserData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      await _fetchUserData(currentUser.uid);
    }
  }

  Future<UserModel?> getCurrentUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('employees')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 10));

      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  void resetStatus() {
    _status = AuthStatus.unknown;
    _safeNotify();
  }

  Future<String?> createEmployee({
    required String email,
    required String password,
    required String fullname,
    required UserRole role,
  }) async {
    FirebaseApp? tempApp;
    try {
      FirebaseOptions currentOptions = Firebase.app().options;
      tempApp = await Firebase.initializeApp(
        name: 'tempEmployeeRegister',
        options: currentOptions,
      );

      UserCredential userCredential = await FirebaseAuth.instanceFor(
        app: tempApp,
      ).createUserWithEmailAndPassword(email: email, password: password);

      String newUid = userCredential.user!.uid;

      UserModel newUser = UserModel(
        uid: newUid,
        email: email,
        fullname: fullname,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      WriteBatch batch = _firestore.batch();

      DocumentReference employeeRef = _firestore
          .collection('employees')
          .doc(newUid);
      batch.set(employeeRef, newUser.toMap());

      await batch.commit();

      await tempApp.delete();
      return null;
    } on FirebaseAuthException catch (e) {
      if (tempApp != null) await tempApp.delete();
      return 'Something went wrong. Please try again. ${e.message}';
    } catch (e) {
      if (tempApp != null) await tempApp.delete();
      return 'Something went wrong. Contact IT support.';
    }
  }
}
