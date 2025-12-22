import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/reimbursement/models/reimbursement_model.dart';
import 'package:uuid/uuid.dart';

class ReimbursementController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ReimbursementModel> _reimbursements = [];
  List<ReimbursementModel> _myReimbursements = [];
  bool _isLoading = false;
  bool _hasData = false;
  String _currentFilter = 'All';
  String _searchQuery = '';
  bool _isDisposed = false;
  String? _errorMessage;

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  List<ReimbursementModel> get reimbursements => _filteredList;
  List<ReimbursementModel> get myReimbursements => _myReimbursements;
  bool get isLoading => _isLoading;
  bool get hasData => _hasData;
  String get currentFilter => _currentFilter;
  String? get errorMessage => _errorMessage;

  int get pendingCount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.pending)
      .length;
  int get approvedCount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.approved)
      .length;
  int get paidCount =>
      _reimbursements.where((r) => r.status == ReimbursementStatus.paid).length;
  int get rejectedCount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.rejected)
      .length;

  double get totalPendingAmount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.pending)
      .fold(0.0, (acc, r) => acc + r.amount);

  double get totalApprovedAmount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.approved)
      .fold(0.0, (acc, r) => acc + r.amount);

  double get totalPaidAmount => _reimbursements
      .where((r) => r.status == ReimbursementStatus.paid)
      .fold(0.0, (acc, r) => acc + r.amount);

  List<ReimbursementModel> get _filteredList {
    return _reimbursements.where((r) {
      final matchesFilter =
          _currentFilter == 'All' ||
          r.status.name.toLowerCase() == _currentFilter.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          r.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      Future.microtask(() {
        if (!_isDisposed) notifyListeners();
      });
    }
  }

  void clearError() {
    _errorMessage = null;
    _safeNotify();
  }

  void setFilter(String filter) {
    if (_isDisposed) return;
    _currentFilter = filter;
    _safeNotify();
  }

  void setSearchQuery(String query) {
    if (_isDisposed) return;
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _safeNotify();
    });
  }

  Future<void> fetchReimbursements({bool forceRefresh = false}) async {
    if (_isDisposed) return;
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final snapshot = await _firestore
          .collection('reimbursements')
          .get()
          .timeout(const Duration(seconds: 15));

      if (_isDisposed) return;

      _reimbursements = snapshot.docs
          .map((doc) => ReimbursementModel.fromMap(doc.data()))
          .toList();

      _reimbursements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _hasData = true;
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again.';
      _reimbursements = [];
      _hasData = true;
    } catch (e) {
      debugPrint('Error fetching reimbursements: $e');
      _errorMessage = 'Failed to load reimbursements.';
      _reimbursements = [];
      _hasData = true;
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  Future<void> fetchMyReimbursements(String userId) async {
    if (_isDisposed) return;
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final snapshot = await _firestore
          .collection('reimbursements')
          .where('uid', isEqualTo: userId)
          .get()
          .timeout(const Duration(seconds: 15));

      if (_isDisposed) return;

      _myReimbursements = snapshot.docs
          .map((doc) => ReimbursementModel.fromMap(doc.data()))
          .toList();

      _myReimbursements.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _hasData = true;
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again.';
      _myReimbursements = [];
    } catch (e) {
      debugPrint('Error fetching my reimbursements: $e');
      _errorMessage = 'Failed to load your reimbursements.';
      _myReimbursements = [];
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  Future<bool> submitReimbursement({
    required String uid,
    required String employeeName,
    required UserRole requesterRole,
    required ReimbursementType type,
    required double amount,
    required String description,
    required DateTime expenseDate,
    String? receiptUrl,
  }) async {
    if (_isDisposed) return false;
    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final id = const Uuid().v4();
      final reimbursement = ReimbursementModel(
        id: id,
        uid: uid,
        employeeName: employeeName,
        requesterRole: requesterRole,
        type: type,
        amount: amount,
        description: description,
        receiptUrl: receiptUrl,
        expenseDate: expenseDate,
        status: ReimbursementStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('reimbursements')
          .doc(id)
          .set(reimbursement.toMap())
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return false;

      _myReimbursements.insert(0, reimbursement);
      _safeNotify();
      return true;
    } on TimeoutException {
      _errorMessage = 'Request timed out. Please try again.';
      return false;
    } catch (e) {
      debugPrint('Error submitting reimbursement: $e');
      _errorMessage = 'Failed to submit reimbursement.';
      return false;
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  Future<bool> approveReimbursement(String id, String approverName) async {
    if (_isDisposed) return false;

    try {
      await _firestore
          .collection('reimbursements')
          .doc(id)
          .update({
            'status': ReimbursementStatus.approved.name,
            'approvedBy': approverName,
            'approvedAt': Timestamp.now(),
          })
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return false;

      final index = _reimbursements.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reimbursements[index] = _reimbursements[index].copyWith(
          status: ReimbursementStatus.approved,
          approvedBy: approverName,
          approvedAt: DateTime.now(),
        );
        _safeNotify();
      }
      return true;
    } catch (e) {
      debugPrint('Error approving reimbursement: $e');
      _errorMessage = 'Failed to approve reimbursement.';
      _safeNotify();
      return false;
    }
  }

  Future<bool> rejectReimbursement(String id, String reason) async {
    if (_isDisposed) return false;

    try {
      await _firestore
          .collection('reimbursements')
          .doc(id)
          .update({
            'status': ReimbursementStatus.rejected.name,
            'rejectionReason': reason,
          })
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return false;

      final index = _reimbursements.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reimbursements[index] = _reimbursements[index].copyWith(
          status: ReimbursementStatus.rejected,
          rejectionReason: reason,
        );
        _safeNotify();
      }
      return true;
    } catch (e) {
      debugPrint('Error rejecting reimbursement: $e');
      _errorMessage = 'Failed to reject reimbursement.';
      _safeNotify();
      return false;
    }
  }

  Future<bool> markAsPaid(String id) async {
    if (_isDisposed) return false;

    try {
      await _firestore
          .collection('reimbursements')
          .doc(id)
          .update({
            'status': ReimbursementStatus.paid.name,
            'paidAt': Timestamp.now(),
          })
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return false;

      final index = _reimbursements.indexWhere((r) => r.id == id);
      if (index != -1) {
        _reimbursements[index] = _reimbursements[index].copyWith(
          status: ReimbursementStatus.paid,
          paidAt: DateTime.now(),
        );
        _safeNotify();
      }
      return true;
    } catch (e) {
      debugPrint('Error marking as paid: $e');
      _errorMessage = 'Failed to mark as paid.';
      _safeNotify();
      return false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}
