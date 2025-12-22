import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  void _safeNotify() {
    if (!_isDisposed) {
      Future.microtask(() {
        if (!_isDisposed) notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    _safeNotify();
  }

  void clearError() {
    if (_isDisposed) return;
    _errorMessage = null;
    _safeNotify();
  }

  Future<void> updateProfile(String uid, String fullname) async {
    if (_isDisposed) return;
    _setLoading(true);
    _errorMessage = null;

    try {
      await _firestore.collection('employees').doc(uid).update({
        'fullname': fullname,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      _errorMessage = e.message ?? 'Failed to update profile';
      rethrow;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      debugPrint('Error updating profile: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    if (_isDisposed) return;
    _setLoading(true);
    _errorMessage = null;

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _errorMessage = 'No user logged in';
        throw Exception(_errorMessage);
      }

      if (user.email == null) {
        _errorMessage = 'User email not found';
        throw Exception(_errorMessage);
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          _errorMessage = 'Current password is incorrect';
          break;
        case 'weak-password':
          _errorMessage = 'New password is too weak';
          break;
        case 'requires-recent-login':
          _errorMessage = 'Please login again and retry';
          break;
        default:
          _errorMessage = e.message ?? 'Failed to change password';
      }
      debugPrint('Error changing password: $e');
      rethrow;
    } catch (e) {
      _errorMessage ??= 'An unexpected error occurred';
      debugPrint('Error changing password: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
