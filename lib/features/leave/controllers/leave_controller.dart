import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';

class LeaveController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<LeaveModel> _leaveList = [];
  List<LeaveModel> _myLeaveList = [];
  Map<String, Map<String, int>> _leaveBalance = {};
  bool _isLoading = false;
  bool _hasData = false;
  String _currentFilter = 'All';
  String _searchQuery = '';
  bool _isDisposed = false;
  UserRole? _currentUserRole;

  Timer? _debounceTimer;

  List<LeaveModel> get leaveList => _filteredList;
  List<LeaveModel> get leaves => _myLeaveList;
  List<LeaveModel> get myLeaveList => _myLeaveList;
  Map<String, Map<String, int>> get leaveBalance => _leaveBalance;
  bool get isLoading => _isLoading;
  bool get hasData => _hasData;
  String get currentFilter => _currentFilter;

  List<LeaveModel> get approvableLeaves {
    if (_currentUserRole == null) return [];
    return _leaveList.where((leave) {
      return leave.status == LeaveStatus.pending &&
          leave.canBeApprovedBy(_currentUserRole!);
    }).toList();
  }

  List<LeaveModel> get _filteredList {
    return _leaveList.where((leave) {
      final matchesFilter =
          _currentFilter == 'All' ||
          leave.status.name.toLowerCase() == _currentFilter.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          leave.employeeName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  int get pendingCount =>
      _leaveList.where((l) => l.status == LeaveStatus.pending).length;
  int get approvedCount =>
      _leaveList.where((l) => l.status == LeaveStatus.approved).length;
  int get rejectedCount =>
      _leaveList.where((l) => l.status == LeaveStatus.rejected).length;

  int get approvablePendingCount => approvableLeaves.length;

  void _safeNotify() {
    if (!_isDisposed) {
      Future.microtask(() {
        if (!_isDisposed) notifyListeners();
      });
    }
  }

  void setCurrentUserRole(UserRole role) {
    _currentUserRole = role;
    _safeNotify();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    _safeNotify();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _safeNotify();
    });
  }

  Future<void> fetchLeaves({
    bool forceRefresh = false,
    UserRole? forRole,
  }) async {
    if (_isDisposed) return;
    _isLoading = true;
    if (forRole != null) _currentUserRole = forRole;
    _safeNotify();

    try {
      Query query = _firestore.collection('leaves');

      if (_currentUserRole == UserRole.supervisor) {
        query = query.where('requesterRole', isEqualTo: UserRole.employee.name);
      } else if (_currentUserRole == UserRole.hrd) {
        query = query.where(
          'requesterRole',
          whereIn: [
            UserRole.supervisor.name,
            UserRole.finance.name,
            UserRole.admin.name,
          ],
        );
      } else if (_currentUserRole == UserRole.admin) {
        query = query.where('requesterRole', isEqualTo: UserRole.hrd.name);
      }

      final snapshot = await query.get();

      _leaveList = snapshot.docs.map((doc) {
        return LeaveModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      _leaveList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _hasData = true;
    } catch (e) {
      debugPrint('Error fetching leaves: $e');
      _leaveList = [];
      _hasData = true;
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> fetchMyLeaves(String userId) async {
    if (_isDisposed) return;
    _isLoading = true;
    _safeNotify();

    try {
      final snapshot = await _firestore
          .collection('leaves')
          .where('uid', isEqualTo: userId)
          .get();

      _myLeaveList = snapshot.docs.map((doc) {
        return LeaveModel.fromMap(doc.data());
      }).toList();

      _myLeaveList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _hasData = true;
    } catch (e) {
      debugPrint('Error fetching my leaves: $e');
      _myLeaveList = [];
      _hasData = true;
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> submitLeaveRequest({
    required String uid,
    required String employeeName,
    required UserRole requesterRole,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    if (_isDisposed) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final leave = LeaveModel(
      id: id,
      uid: uid,
      employeeName: employeeName,
      requesterRole: requesterRole,
      type: type,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: LeaveStatus.pending,
      createdAt: DateTime.now(),
    );

    try {
      await _firestore.collection('leaves').doc(id).set(leave.toMap());
      _myLeaveList.insert(0, leave);
      _leaveList.insert(0, leave);
      _safeNotify();
    } catch (e) {
      debugPrint('Error submitting leave: $e');
      _myLeaveList.insert(0, leave);
      _leaveList.insert(0, leave);
      _safeNotify();
    }
  }

  Future<void> updateLeave(
    String leaveId, {
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    if (_isDisposed) return;

    try {
      await _firestore.collection('leaves').doc(leaveId).update({
        'type': type.name,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'reason': reason,
      });

      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          type: type,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
        ),
      );
      _safeNotify();
    } catch (e) {
      debugPrint('Error updating leave: $e');
      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          type: type,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
        ),
      );
      _safeNotify();
    }
  }

  void _updateLeaveInLists(
    String leaveId,
    LeaveModel Function(LeaveModel) updater,
  ) {
    final myIndex = _myLeaveList.indexWhere((l) => l.id == leaveId);
    if (myIndex != -1) {
      _myLeaveList[myIndex] = updater(_myLeaveList[myIndex]);
    }
    final index = _leaveList.indexWhere((l) => l.id == leaveId);
    if (index != -1) {
      _leaveList[index] = updater(_leaveList[index]);
    }
  }

  Future<void> cancelLeave(String leaveId) async {
    if (_isDisposed) return;

    try {
      await _firestore.collection('leaves').doc(leaveId).delete();
      _myLeaveList.removeWhere((l) => l.id == leaveId);
      _leaveList.removeWhere((l) => l.id == leaveId);
      _safeNotify();
    } catch (e) {
      debugPrint('Error cancelling leave: $e');
      _myLeaveList.removeWhere((l) => l.id == leaveId);
      _leaveList.removeWhere((l) => l.id == leaveId);
      _safeNotify();
    }
  }

  Future<void> approveLeave(
    String leaveId,
    String approvedBy,
    UserRole approverRole,
  ) async {
    if (_isDisposed) return;

    final leave = _leaveList.firstWhere(
      (l) => l.id == leaveId,
      orElse: () => _myLeaveList.firstWhere((l) => l.id == leaveId),
    );

    if (!leave.canBeApprovedBy(approverRole)) {
      debugPrint('User does not have permission to approve this leave');
      return;
    }

    try {
      await _firestore.collection('leaves').doc(leaveId).update({
        'status': LeaveStatus.approved.name,
        'approvedBy': approvedBy,
        'approvedAt': Timestamp.now(),
      });

      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          status: LeaveStatus.approved,
          approvedBy: approvedBy,
          approvedAt: DateTime.now(),
        ),
      );
      _safeNotify();
    } catch (e) {
      debugPrint('Error approving leave: $e');
      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          status: LeaveStatus.approved,
          approvedBy: approvedBy,
          approvedAt: DateTime.now(),
        ),
      );
      _safeNotify();
    }
  }

  Future<void> rejectLeave(
    String leaveId,
    String reason,
    UserRole rejecterRole,
  ) async {
    if (_isDisposed) return;

    final leave = _leaveList.firstWhere(
      (l) => l.id == leaveId,
      orElse: () => _myLeaveList.firstWhere((l) => l.id == leaveId),
    );

    if (!leave.canBeApprovedBy(rejecterRole)) {
      debugPrint('User does not have permission to reject this leave');
      return;
    }

    try {
      await _firestore.collection('leaves').doc(leaveId).update({
        'status': LeaveStatus.rejected.name,
        'rejectionReason': reason,
      });

      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          status: LeaveStatus.rejected,
          rejectionReason: reason,
        ),
      );
      _safeNotify();
    } catch (e) {
      debugPrint('Error rejecting leave: $e');
      _updateLeaveInLists(
        leaveId,
        (leave) => leave.copyWith(
          status: LeaveStatus.rejected,
          rejectionReason: reason,
        ),
      );
      _safeNotify();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }

  static const Map<String, int> defaultQuotas = {
    'annual': 12,
    'sick': 6,
    'personal': 2,
  };

  static const int maxLeaveDaysPerYear = 20;

  int get totalRemainingDays {
    int total = 0;
    _leaveBalance.forEach((key, value) {
      total += value['remaining'] ?? 0;
    });
    return total;
  }

  int get totalUsedDays {
    int total = 0;
    _leaveBalance.forEach((key, value) {
      total += value['used'] ?? 0;
    });
    return total;
  }

  Future<void> fetchLeaveBalance(String userId) async {
    if (_isDisposed) return;
    _isLoading = true;
    _safeNotify();

    try {
      await _calculateLeaveBalanceFromFirebase(userId);
      await fetchMyLeaves(userId);
    } catch (e) {
      debugPrint('Error fetching leave balance: $e');
      _leaveBalance = {
        'annual': {
          'total': defaultQuotas['annual']!,
          'remaining': defaultQuotas['annual']!,
          'used': 0,
        },
        'sick': {
          'total': defaultQuotas['sick']!,
          'remaining': defaultQuotas['sick']!,
          'used': 0,
        },
        'personal': {
          'total': defaultQuotas['personal']!,
          'remaining': defaultQuotas['personal']!,
          'used': 0,
        },
      };
    } finally {
      _isLoading = false;
      _safeNotify();
    }
  }

  Future<void> _calculateLeaveBalanceFromFirebase(String userId) async {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31, 23, 59, 59);

    try {
      final snapshot = await _firestore
          .collection('leaves')
          .where('uid', isEqualTo: userId)
          .where('status', isEqualTo: 'approved')
          .get();

      Map<String, int> usedDays = {'annual': 0, 'sick': 0, 'personal': 0};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final startDate = (data['startDate'] as Timestamp?)?.toDate();
        final endDate = (data['endDate'] as Timestamp?)?.toDate();

        if (startDate == null || endDate == null) continue;

        if (startDate.year != now.year && endDate.year != now.year) continue;

        final effectiveStart = startDate.isBefore(startOfYear)
            ? startOfYear
            : startDate;
        final effectiveEnd = endDate.isAfter(endOfYear) ? endOfYear : endDate;

        final days = effectiveEnd.difference(effectiveStart).inDays + 1;
        final type = data['type']?.toString().toLowerCase() ?? '';

        if (usedDays.containsKey(type)) {
          usedDays[type] = usedDays[type]! + days;
        }
      }

      _leaveBalance = {
        'annual': {
          'total': defaultQuotas['annual']!,
          'remaining': (defaultQuotas['annual']! - usedDays['annual']!).clamp(
            0,
            defaultQuotas['annual']!,
          ),
          'used': usedDays['annual']!,
        },
        'sick': {
          'total': defaultQuotas['sick']!,
          'remaining': (defaultQuotas['sick']! - usedDays['sick']!).clamp(
            0,
            defaultQuotas['sick']!,
          ),
          'used': usedDays['sick']!,
        },
        'personal': {
          'total': defaultQuotas['personal']!,
          'remaining': (defaultQuotas['personal']! - usedDays['personal']!)
              .clamp(0, defaultQuotas['personal']!),
          'used': usedDays['personal']!,
        },
      };

      debugPrint('Leave balance calculated: $_leaveBalance');
    } catch (e) {
      debugPrint('Error calculating leave balance: $e');
      _leaveBalance = {
        'annual': {
          'total': defaultQuotas['annual']!,
          'remaining': defaultQuotas['annual']!,
          'used': 0,
        },
        'sick': {
          'total': defaultQuotas['sick']!,
          'remaining': defaultQuotas['sick']!,
          'used': 0,
        },
        'personal': {
          'total': defaultQuotas['personal']!,
          'remaining': defaultQuotas['personal']!,
          'used': 0,
        },
      };
    }
  }

  bool hasEnoughBalance(LeaveType type, int requestedDays) {
    final typeKey = type.name.toLowerCase();
    if (!_leaveBalance.containsKey(typeKey)) return false;
    final remaining = _leaveBalance[typeKey]?['remaining'] ?? 0;
    return remaining >= requestedDays;
  }

  Future<void> refreshLeaveBalance(String userId) async {
    await _calculateLeaveBalanceFromFirebase(userId);
    _safeNotify();
  }
}
