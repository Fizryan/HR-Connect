import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';

class UserManagementController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = false;
  bool _hasData = false;
  String _searchQuery = '';
  String _currentFilter = 'All';

  bool _isDisposed = false;

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  List<UserModel> get users => _filteredUsers;
  bool get isLoading => _isLoading;
  String get currentFilter => _currentFilter;
  bool get hasData => _hasData;

  void _safeNotify() {
    if (!_isDisposed) {
      Future.microtask(() {
        if (!_isDisposed) notifyListeners();
      });
    }
  }

  bool get _isCacheValid {
    if (!_hasData || _lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  Future<void> fetchUsers({bool forceRefresh = false}) async {
    if (_isDisposed) return;

    if (!forceRefresh && _isCacheValid) {
      return;
    }
    _isLoading = true;
    _safeNotify();

    try {
      final snapshot = await _firestore
          .collection('employees')
          .orderBy('createdAt', descending: true)
          .get(const GetOptions(source: Source.serverAndCache));

      if (_isDisposed) return;

      _allUsers = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromMap(data);
      }).toList();

      _hasData = true;
      _lastFetchTime = DateTime.now();
      _applyFilterAndSearch();
    } catch (e) {
      debugPrint('Error fetching users: $e');
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }

  void setSearchQuery(String query) {
    if (_isDisposed) return;
    _searchQuery = query;

    _debounceTimer?.cancel();

    _debounceTimer = Timer(_debounceDuration, () {
      _applyFilterAndSearch();
    });
  }

  void setFilter(String filter) {
    if (_isDisposed) return;
    _currentFilter = filter;
    _applyFilterAndSearch();
  }

  void _applyFilterAndSearch() {
    if (_isDisposed) return;

    _filteredUsers = _allUsers.where((user) {
      bool matchesFilter = true;
      if (_currentFilter != 'All') {
        matchesFilter =
            user.status.toLowerCase() == _currentFilter.toLowerCase();
      }

      bool matchesSearch = true;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        matchesSearch =
            user.fullname.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query);
      }

      return matchesFilter && matchesSearch;
    }).toList();

    _safeNotify();
  }

  Future<void> addUser(
    UserModel user,
    String password,
    String adminEmail,
    String adminPassword,
  ) async {
    if (_isDisposed) return;

    try {
      final newUserCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final newUserId = newUserCredential.user!.uid;
      final newUser = user.copyWith(uid: newUserId);

      await _firestore
          .collection('employees')
          .doc(newUser.uid)
          .set(newUser.toMap());

      await _auth.signOut();
      await _auth.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );

      if (_isDisposed) return;

      _allUsers.insert(0, newUser);
      _applyFilterAndSearch();
    } catch (e) {
      try {
        await _auth.signOut();
        await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
      } catch (_) {}
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    if (_isDisposed) return;

    try {
      await _firestore
          .collection('employees')
          .doc(user.uid)
          .update(user.toMap());

      if (_isDisposed) return;

      final index = _allUsers.indexWhere((u) => u.uid == user.uid);
      if (index != -1) {
        _allUsers[index] = user;
        _applyFilterAndSearch();
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    if (_isDisposed) return;

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.uid == uid) {
        throw Exception('Cannot delete your own account');
      }

      await _firestore.collection('employees').doc(uid).delete();

      if (_isDisposed) return;

      _allUsers.removeWhere((u) => u.uid == uid);
      _applyFilterAndSearch();
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }
}
