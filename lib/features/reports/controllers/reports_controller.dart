import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/attendance/models/attendance_model.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';
import 'package:hr_connect/features/leave/models/leave_model.dart';
import 'package:hr_connect/features/reimbursement/models/reimbursement_model.dart';

class ReportData {
  final int totalEmployees;
  final int activeEmployees;
  final double attendanceRate;
  final double leaveUtilization;
  final double avgWorkHours;
  final int pendingLeaves;
  final int approvedLeaves;
  final int rejectedLeaves;
  final List<AttendanceModel> attendanceRecords;
  final List<LeaveModel> leaveRecords;
  final List<ReimbursementModel> reimbursementRecords;
  final Map<String, int> attendanceByStatus;
  final Map<String, int> leaveByType;
  final Map<String, double> reimbursementByType;
  final double totalReimbursementAmount;
  final double pendingReimbursementAmount;
  final double approvedReimbursementAmount;
  final double paidReimbursementAmount;
  final int pendingReimbursements;
  final int approvedReimbursements;
  final int paidReimbursements;
  final int rejectedReimbursements;

  ReportData({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.attendanceRate,
    required this.leaveUtilization,
    required this.avgWorkHours,
    required this.pendingLeaves,
    required this.approvedLeaves,
    required this.rejectedLeaves,
    required this.attendanceRecords,
    required this.leaveRecords,
    required this.reimbursementRecords,
    required this.attendanceByStatus,
    required this.leaveByType,
    required this.reimbursementByType,
    required this.totalReimbursementAmount,
    required this.pendingReimbursementAmount,
    required this.approvedReimbursementAmount,
    required this.paidReimbursementAmount,
    required this.pendingReimbursements,
    required this.approvedReimbursements,
    required this.paidReimbursements,
    required this.rejectedReimbursements,
  });
}

class ReportsController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReportData? _reportData;
  bool _isLoading = false;
  String _selectedPeriod = 'This Month';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  UserRole? _currentUserRole;

  bool _isDisposed = false;

  static const double totalAnnualBudget = 1000000000.0;

  ReportData? get reportData => _reportData;
  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  UserRole? get currentUserRole => _currentUserRole;

  double get remainingBudget {
    final used = _reportData?.paidReimbursementAmount ?? 0;
    return totalAnnualBudget - used;
  }

  double get budgetUtilization {
    final used = _reportData?.paidReimbursementAmount ?? 0;
    return (used / totalAnnualBudget) * 100;
  }

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

  void setUserRole(UserRole role) {
    _currentUserRole = role;
    _safeNotify();
  }

  void setPeriod(String period) {
    if (_isDisposed) return;
    _selectedPeriod = period;
    _calculateDateRange();
    fetchReportData();
  }

  void _calculateDateRange() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'This Week':
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = now;
        break;
      case 'This Month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
      case 'This Quarter':
        final quarter = ((now.month - 1) ~/ 3) * 3 + 1;
        _startDate = DateTime(now.year, quarter, 1);
        _endDate = now;
        break;
      case 'This Year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        break;
      default:
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
    }
  }

  Future<void> fetchReportData({bool forceRefresh = false}) async {
    if (_isDisposed) return;

    _isLoading = true;
    _safeNotify();

    try {
      _calculateDateRange();

      final attendanceSnapshot = await _firestore
          .collection('attendance')
          .get();

      if (_isDisposed) return;

      final attendanceRecords = attendanceSnapshot.docs
          .map((doc) => AttendanceModel.fromMap(doc.data()))
          .where((record) {
            return record.date.isAfter(
                  _startDate.subtract(const Duration(days: 1)),
                ) &&
                record.date.isBefore(_endDate.add(const Duration(days: 1)));
          })
          .toList();

      final leaveSnapshot = await _firestore.collection('leaves').get();

      if (_isDisposed) return;

      final leaveRecords = leaveSnapshot.docs
          .map((doc) => LeaveModel.fromMap(doc.data()))
          .where((leave) {
            return leave.createdAt.isAfter(
                  _startDate.subtract(const Duration(days: 1)),
                ) &&
                leave.createdAt.isBefore(_endDate.add(const Duration(days: 1)));
          })
          .toList();

      final reimbursementSnapshot = await _firestore
          .collection('reimbursements')
          .get();

      if (_isDisposed) return;

      final reimbursementRecords = reimbursementSnapshot.docs
          .map((doc) => ReimbursementModel.fromMap(doc.data()))
          .where((r) {
            return r.createdAt.isAfter(
                  _startDate.subtract(const Duration(days: 1)),
                ) &&
                r.createdAt.isBefore(_endDate.add(const Duration(days: 1)));
          })
          .toList();

      final yearStart = DateTime(DateTime.now().year, 1, 1);
      final allYearReimbursements = reimbursementSnapshot.docs
          .map((doc) => ReimbursementModel.fromMap(doc.data()))
          .where(
            (r) => r.createdAt.isAfter(
              yearStart.subtract(const Duration(days: 1)),
            ),
          )
          .toList();

      final usersSnapshot = await _firestore.collection('employees').get();

      if (_isDisposed) return;

      final totalEmployees = usersSnapshot.docs.length;
      final activeEmployees = usersSnapshot.docs
          .where((doc) => doc.data()['isActive'] == true)
          .length;

      final attendanceByStatus = <String, int>{};
      for (var record in attendanceRecords) {
        final status = record.status.name;
        attendanceByStatus[status] = (attendanceByStatus[status] ?? 0) + 1;
      }

      final leaveByType = <String, int>{};
      for (var leave in leaveRecords) {
        final type = leave.type.name;
        leaveByType[type] = (leaveByType[type] ?? 0) + 1;
      }

      final reimbursementByType = <String, double>{};
      for (var r in reimbursementRecords) {
        final type = r.typeText;
        reimbursementByType[type] = (reimbursementByType[type] ?? 0) + r.amount;
      }

      final presentCount = attendanceByStatus['present'] ?? 0;
      final totalAttendance = attendanceRecords.length;
      final attendanceRate = totalAttendance > 0
          ? (presentCount / totalAttendance) * 100
          : 0.0;

      double totalHours = 0;
      int countWithHours = 0;
      for (var record in attendanceRecords) {
        if (record.checkIn != null && record.checkOut != null) {
          final hours =
              record.checkOut!.difference(record.checkIn!).inMinutes / 60;
          totalHours += hours;
          countWithHours++;
        }
      }
      final avgWorkHours = countWithHours > 0
          ? totalHours / countWithHours
          : 0.0;

      final pendingLeaves = leaveRecords
          .where((l) => l.status == LeaveStatus.pending)
          .length;
      final approvedLeaves = leaveRecords
          .where((l) => l.status == LeaveStatus.approved)
          .length;
      final rejectedLeaves = leaveRecords
          .where((l) => l.status == LeaveStatus.rejected)
          .length;

      final leaveUtilization = leaveRecords.isNotEmpty
          ? (approvedLeaves / leaveRecords.length) * 100
          : 0.0;

      final pendingReimbursements = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.pending)
          .length;
      final approvedReimbursements = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.approved)
          .length;
      final paidReimbursements = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.paid)
          .length;
      final rejectedReimbursements = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.rejected)
          .length;

      final pendingReimbursementAmount = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.pending)
          .fold(0.0, (acc, r) => acc + r.amount);
      final approvedReimbursementAmount = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.approved)
          .fold(0.0, (acc, r) => acc + r.amount);
      final paidReimbursementAmount = allYearReimbursements
          .where((r) => r.status == ReimbursementStatus.paid)
          .fold(0.0, (acc, r) => acc + r.amount);
      final totalReimbursementAmount =
          pendingReimbursementAmount +
          approvedReimbursementAmount +
          paidReimbursementAmount;

      _reportData = ReportData(
        totalEmployees: totalEmployees,
        activeEmployees: activeEmployees,
        attendanceRate: attendanceRate,
        leaveUtilization: leaveUtilization,
        avgWorkHours: avgWorkHours,
        pendingLeaves: pendingLeaves,
        approvedLeaves: approvedLeaves,
        rejectedLeaves: rejectedLeaves,
        attendanceRecords: attendanceRecords,
        leaveRecords: leaveRecords,
        reimbursementRecords: reimbursementRecords,
        attendanceByStatus: attendanceByStatus.isNotEmpty
            ? attendanceByStatus
            : {'present': 0, 'late': 0, 'absent': 0, 'leave': 0},
        leaveByType: leaveByType.isNotEmpty
            ? leaveByType
            : {'annual': 0, 'sick': 0, 'personal': 0, 'unpaid': 0},
        reimbursementByType: reimbursementByType,
        totalReimbursementAmount: totalReimbursementAmount,
        pendingReimbursementAmount: pendingReimbursementAmount,
        approvedReimbursementAmount: approvedReimbursementAmount,
        paidReimbursementAmount: paidReimbursementAmount,
        pendingReimbursements: pendingReimbursements,
        approvedReimbursements: approvedReimbursements,
        paidReimbursements: paidReimbursements,
        rejectedReimbursements: rejectedReimbursements,
      );
    } catch (e) {
      debugPrint('Error fetching report data: $e');
      if (_isDisposed) return;

      _reportData = ReportData(
        totalEmployees: 0,
        activeEmployees: 0,
        attendanceRate: 0.0,
        leaveUtilization: 0.0,
        avgWorkHours: 0.0,
        pendingLeaves: 0,
        approvedLeaves: 0,
        rejectedLeaves: 0,
        attendanceRecords: [],
        leaveRecords: [],
        reimbursementRecords: [],
        attendanceByStatus: {'present': 0, 'late': 0, 'absent': 0, 'leave': 0},
        leaveByType: {'annual': 0, 'sick': 0, 'personal': 0, 'unpaid': 0},
        reimbursementByType: {},
        totalReimbursementAmount: 0,
        pendingReimbursementAmount: 0,
        approvedReimbursementAmount: 0,
        paidReimbursementAmount: 0,
        pendingReimbursements: 0,
        approvedReimbursements: 0,
        paidReimbursements: 0,
        rejectedReimbursements: 0,
      );
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }
}
