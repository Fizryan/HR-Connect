import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/attendance/models/attendance_model.dart';

class AttendanceConfig {
  static const int workStartHour = 9;
  static const int workStartMinute = 0;

  static const int minimumFullDayHours = 8;

  static const int minimumHalfDayHours = 4;

  static const int lateGraceMinutes = 15;

  static const int maxCheckInHour = 12;

  static const int workEndHour = 17;
  static const int workEndMinute = 0;
}

class AttendanceResult {
  final bool success;
  final String message;
  final AttendanceModel? attendance;
  final AttendanceError? error;

  AttendanceResult._({
    required this.success,
    required this.message,
    this.attendance,
    this.error,
  });

  factory AttendanceResult.success(
    String message, {
    AttendanceModel? attendance,
  }) {
    return AttendanceResult._(
      success: true,
      message: message,
      attendance: attendance,
    );
  }

  factory AttendanceResult.failure(String message, AttendanceError error) {
    return AttendanceResult._(success: false, message: message, error: error);
  }
}

enum AttendanceError {
  alreadyCheckedIn,
  notCheckedIn,
  alreadyCheckedOut,
  networkError,
  serverError,
  invalidUser,
  tooEarlyToCheckIn,
  tooLateToCheckIn,
  unknown,
}

class AttendanceController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AttendanceModel> _attendanceList = [];
  AttendanceModel? _todayAttendance;
  bool _isLoading = false;
  bool _hasData = false;
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';
  String? _errorMessage;
  bool _isOffline = false;

  bool _isDisposed = false;

  Timer? _debounceTimer;
  Timer? _autoRefreshTimer;

  List<AttendanceModel> get attendanceList => _filteredList;
  AttendanceModel? get todayAttendance => _todayAttendance;
  bool get isLoading => _isLoading;
  bool get hasData => _hasData;
  DateTime get selectedDate => _selectedDate;
  String? get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;

  bool get canCheckIn {
    if (_todayAttendance != null) return false;
    final now = DateTime.now();
    if (now.hour >= AttendanceConfig.maxCheckInHour + 3) return false;
    return true;
  }

  bool get canCheckOut {
    if (_todayAttendance == null) return false;
    if (_todayAttendance!.checkIn == null) return false;
    if (_todayAttendance!.checkOut != null) return false;
    return true;
  }

  DateTime? get expectedCheckOutTime {
    if (_todayAttendance?.checkIn == null) return null;
    return _todayAttendance!.checkIn!.add(
      const Duration(hours: AttendanceConfig.minimumFullDayHours),
    );
  }

  Duration? get remainingWorkTime {
    if (_todayAttendance?.checkIn == null) return null;
    if (_todayAttendance?.checkOut != null) return Duration.zero;
    final expected = expectedCheckOutTime;
    if (expected == null) return null;
    final remaining = expected.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  List<AttendanceModel> get _filteredList {
    if (_searchQuery.isEmpty) return _attendanceList;
    return _attendanceList.where((a) {
      return a.employeeName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int get presentCount =>
      _attendanceList.where((a) => a.status == AttendanceStatus.present).length;
  int get absentCount =>
      _attendanceList.where((a) => a.status == AttendanceStatus.absent).length;
  int get lateCount =>
      _attendanceList.where((a) => a.status == AttendanceStatus.late).length;
  int get leaveCount =>
      _attendanceList.where((a) => a.status == AttendanceStatus.leave).length;
  int get halfDayCount =>
      _attendanceList.where((a) => a.status == AttendanceStatus.halfDay).length;
  int get totalCount => _attendanceList.length;

  double get attendanceRate {
    if (totalCount == 0) return 0;
    final attended = presentCount + lateCount + halfDayCount;
    return (attended / totalCount) * 100;
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

  void setSearchQuery(String query) {
    if (_isDisposed) return;
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _safeNotify();
    });
  }

  void setSelectedDate(DateTime date) {
    if (_isDisposed) return;
    _selectedDate = date;
    fetchAttendance();
  }

  void startAutoRefresh({Duration interval = const Duration(minutes: 5)}) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(interval, (_) {
      if (!_isDisposed) {
        fetchAttendance(forceRefresh: true);
      }
    });
  }

  void stopAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  Future<void> fetchAttendance({bool forceRefresh = false}) async {
    if (_isDisposed) return;

    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final startOfDay = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('attendance')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .get()
          .timeout(const Duration(seconds: 15));

      if (_isDisposed) return;

      _attendanceList = snapshot.docs.map((doc) {
        return AttendanceModel.fromMap(doc.data());
      }).toList();

      _attendanceList.sort((a, b) => b.date.compareTo(a.date));

      _hasData = true;
      _isOffline = false;
    } on FirebaseException catch (e) {
      debugPrint(
        'Firebase error fetching attendance: ${e.code} - ${e.message}',
      );
      if (_isDisposed) return;

      if (e.code == 'unavailable' || e.code == 'network-request-failed') {
        _isOffline = true;
        _errorMessage = 'Network unavailable. Please check your connection.';
      } else {
        _errorMessage = 'Error loading attendance data.';
      }

      _attendanceList = [];
      _hasData = true;
    } on TimeoutException {
      debugPrint('Timeout fetching attendance');
      if (_isDisposed) return;
      _isOffline = true;
      _errorMessage = 'Request timed out. Please check your connection.';
      _attendanceList = [];
      _hasData = true;
    } catch (e) {
      debugPrint('Error fetching attendance: $e');
      if (_isDisposed) return;
      _errorMessage = 'An unexpected error occurred.';
      _attendanceList = [];
      _hasData = true;
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  Future<void> markAttendance(AttendanceModel attendance) async {
    if (_isDisposed) return;

    try {
      await _firestore
          .collection('attendance')
          .doc(attendance.id)
          .set(attendance.toMap())
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return;

      final index = _attendanceList.indexWhere((a) => a.id == attendance.id);
      if (index != -1) {
        _attendanceList[index] = attendance;
      } else {
        _attendanceList.insert(0, attendance);
      }
      _safeNotify();
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      debugPrint('Error marking attendance: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchTodayAttendance(String userId) async {
    if (_isDisposed) return;

    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('attendance')
          .where('uid', isEqualTo: userId)
          .get()
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) return;

      final todayDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        final date = (data['date'] as Timestamp?)?.toDate();
        if (date == null) return false;
        return date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
            date.isBefore(endOfDay);
      }).toList();

      if (todayDocs.isNotEmpty) {
        _todayAttendance = AttendanceModel.fromMap(todayDocs.first.data());
      } else {
        _todayAttendance = null;
      }
      _isOffline = false;
    } on TimeoutException {
      debugPrint('Timeout fetching today attendance');
      if (_isDisposed) return;
      _isOffline = true;
      _errorMessage = 'Request timed out.';
      _todayAttendance = null;
    } catch (e) {
      debugPrint('Error fetching today attendance: $e');
      if (_isDisposed) return;
      _errorMessage = 'Error loading attendance.';
      _todayAttendance = null;
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        _safeNotify();
      }
    }
  }

  AttendanceStatus _determineCheckInStatus(DateTime checkInTime) {
    final workStart = DateTime(
      checkInTime.year,
      checkInTime.month,
      checkInTime.day,
      AttendanceConfig.workStartHour,
      AttendanceConfig.workStartMinute,
    );

    final graceEnd = workStart.add(
      Duration(minutes: AttendanceConfig.lateGraceMinutes),
    );

    final halfDayThreshold = DateTime(
      checkInTime.year,
      checkInTime.month,
      checkInTime.day,
      AttendanceConfig.maxCheckInHour,
      0,
    );

    if (checkInTime.isBefore(graceEnd) ||
        checkInTime.isAtSameMomentAs(graceEnd)) {
      return AttendanceStatus.present;
    } else if (checkInTime.isBefore(halfDayThreshold)) {
      return AttendanceStatus.late;
    } else {
      return AttendanceStatus.halfDay;
    }
  }

  AttendanceStatus _determineFinalStatus(
    AttendanceStatus checkInStatus,
    DateTime checkIn,
    DateTime checkOut,
  ) {
    final duration = checkOut.difference(checkIn);
    final workedHours = duration.inMinutes / 60;

    if (workedHours < AttendanceConfig.minimumHalfDayHours) {
      return AttendanceStatus.halfDay;
    } else if (workedHours < AttendanceConfig.minimumFullDayHours) {
      if (checkInStatus == AttendanceStatus.halfDay) {
        return AttendanceStatus.halfDay;
      }
      return checkInStatus;
    }

    return checkInStatus;
  }

  Future<AttendanceResult> checkIn(
    String userId, {
    String? employeeName,
  }) async {
    if (_isDisposed) {
      return AttendanceResult.failure(
        'Service unavailable',
        AttendanceError.unknown,
      );
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (now.hour >= (AttendanceConfig.maxCheckInHour + 3)) {
        _isLoading = false;
        _safeNotify();
        return AttendanceResult.failure(
          'Too late to check in. Please contact HR.',
          AttendanceError.tooLateToCheckIn,
        );
      }

      await fetchTodayAttendance(userId);
      if (_isDisposed) {
        return AttendanceResult.failure(
          'Service unavailable',
          AttendanceError.unknown,
        );
      }

      if (_todayAttendance != null) {
        _isLoading = false;
        _safeNotify();
        return AttendanceResult.failure(
          'You have already checked in today.',
          AttendanceError.alreadyCheckedIn,
        );
      }

      final status = _determineCheckInStatus(now);

      String finalEmployeeName = employeeName ?? 'Unknown Employee';
      if (employeeName == null || employeeName.isEmpty) {
        try {
          final userDoc = await _firestore
              .collection('employees')
              .doc(userId)
              .get()
              .timeout(const Duration(seconds: 5));
          if (userDoc.exists) {
            finalEmployeeName =
                userDoc.data()?['fullname'] ?? 'Unknown Employee';
          }
        } catch (e) {
          debugPrint('Error fetching user name: $e');
        }
      }

      if (_isDisposed) {
        return AttendanceResult.failure(
          'Service unavailable',
          AttendanceError.unknown,
        );
      }

      final attendanceId = _firestore.collection('attendance').doc().id;
      final attendance = AttendanceModel(
        id: attendanceId,
        uid: userId,
        employeeName: finalEmployeeName,
        date: today,
        checkIn: now,
        status: status,
        notes: status == AttendanceStatus.late
            ? 'Checked in late at ${_formatTime(now)}'
            : null,
      );

      await _firestore
          .collection('attendance')
          .doc(attendanceId)
          .set(attendance.toMap())
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) {
        return AttendanceResult.failure(
          'Service unavailable',
          AttendanceError.unknown,
        );
      }

      _todayAttendance = attendance;
      _isLoading = false;
      _isOffline = false;
      _safeNotify();

      final statusText = status == AttendanceStatus.present
          ? 'on time'
          : status == AttendanceStatus.late
          ? 'late'
          : 'for half day';

      return AttendanceResult.success(
        'Checked in $statusText at ${_formatTime(now)}',
        attendance: attendance,
      );
    } on TimeoutException {
      if (!_isDisposed) {
        _isLoading = false;
        _isOffline = true;
        _errorMessage = 'Request timed out.';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'Request timed out. Please try again.',
        AttendanceError.networkError,
      );
    } on FirebaseException catch (e) {
      if (!_isDisposed) {
        _isLoading = false;
        _errorMessage = 'Server error: ${e.message}';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'Server error. Please try again.',
        AttendanceError.serverError,
      );
    } catch (e) {
      debugPrint('Error checking in: $e');
      if (!_isDisposed) {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred.';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'An unexpected error occurred.',
        AttendanceError.unknown,
      );
    }
  }

  Future<AttendanceResult> checkOut(String userId) async {
    if (_isDisposed) {
      return AttendanceResult.failure(
        'Service unavailable',
        AttendanceError.unknown,
      );
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      if (_todayAttendance == null) {
        await fetchTodayAttendance(userId);
      }

      if (_isDisposed) {
        return AttendanceResult.failure(
          'Service unavailable',
          AttendanceError.unknown,
        );
      }

      if (_todayAttendance == null || _todayAttendance!.checkIn == null) {
        _isLoading = false;
        _safeNotify();
        return AttendanceResult.failure(
          'You need to check in first.',
          AttendanceError.notCheckedIn,
        );
      }

      if (_todayAttendance!.checkOut != null) {
        _isLoading = false;
        _safeNotify();
        return AttendanceResult.failure(
          'You have already checked out today.',
          AttendanceError.alreadyCheckedOut,
        );
      }

      final now = DateTime.now();

      final finalStatus = _determineFinalStatus(
        _todayAttendance!.status,
        _todayAttendance!.checkIn!,
        now,
      );

      final duration = now.difference(_todayAttendance!.checkIn!);
      final workedHours = duration.inHours;
      final workedMinutes = duration.inMinutes % 60;

      await _firestore
          .collection('attendance')
          .doc(_todayAttendance!.id)
          .update({
            'checkOut': Timestamp.fromDate(now),
            'status': finalStatus.toString().split('.').last,
            'notes': 'Worked ${workedHours}h ${workedMinutes}m',
          })
          .timeout(const Duration(seconds: 10));

      if (_isDisposed) {
        return AttendanceResult.failure(
          'Service unavailable',
          AttendanceError.unknown,
        );
      }

      _todayAttendance = AttendanceModel(
        id: _todayAttendance!.id,
        uid: _todayAttendance!.uid,
        employeeName: _todayAttendance!.employeeName,
        date: _todayAttendance!.date,
        checkIn: _todayAttendance!.checkIn,
        checkOut: now,
        status: finalStatus,
        notes: 'Worked ${workedHours}h ${workedMinutes}m',
      );

      _isLoading = false;
      _isOffline = false;
      _safeNotify();

      return AttendanceResult.success(
        'Checked out at ${_formatTime(now)}. Total: ${workedHours}h ${workedMinutes}m',
        attendance: _todayAttendance,
      );
    } on TimeoutException {
      if (!_isDisposed) {
        _isLoading = false;
        _isOffline = true;
        _errorMessage = 'Request timed out.';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'Request timed out. Please try again.',
        AttendanceError.networkError,
      );
    } on FirebaseException catch (e) {
      if (!_isDisposed) {
        _isLoading = false;
        _errorMessage = 'Server error: ${e.message}';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'Server error. Please try again.',
        AttendanceError.serverError,
      );
    } catch (e) {
      debugPrint('Error checking out: $e');
      if (!_isDisposed) {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred.';
        _safeNotify();
      }
      return AttendanceResult.failure(
        'An unexpected error occurred.',
        AttendanceError.unknown,
      );
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_isDisposed) return [];

    try {
      final snapshot = await _firestore
          .collection('attendance')
          .where('uid', isEqualTo: userId)
          .get()
          .timeout(const Duration(seconds: 15));

      final results = snapshot.docs
          .map((doc) {
            return AttendanceModel.fromMap(doc.data());
          })
          .where((attendance) {
            return attendance.date.isAfter(
                  startDate.subtract(const Duration(days: 1)),
                ) &&
                attendance.date.isBefore(endDate.add(const Duration(days: 1)));
          })
          .toList();

      results.sort((a, b) => b.date.compareTo(a.date));

      return results;
    } catch (e) {
      debugPrint('Error fetching attendance history: $e');
      return [];
    }
  }

  Map<String, dynamic> calculateStatistics(
    List<AttendanceModel> attendanceList,
  ) {
    final total = attendanceList.length;
    final present = attendanceList
        .where((a) => a.status == AttendanceStatus.present)
        .length;
    final late = attendanceList
        .where((a) => a.status == AttendanceStatus.late)
        .length;
    final absent = attendanceList
        .where((a) => a.status == AttendanceStatus.absent)
        .length;
    final leave = attendanceList
        .where((a) => a.status == AttendanceStatus.leave)
        .length;
    final halfDay = attendanceList
        .where((a) => a.status == AttendanceStatus.halfDay)
        .length;

    final attended = present + late + halfDay;
    final attendanceRate = total > 0 ? (attended / total) * 100 : 0.0;
    final punctualityRate = attended > 0 ? (present / attended) * 100 : 0.0;

    double totalHours = 0;
    int countWithHours = 0;
    for (final att in attendanceList) {
      if (att.checkIn != null && att.checkOut != null) {
        totalHours += att.checkOut!.difference(att.checkIn!).inMinutes / 60;
        countWithHours++;
      }
    }
    final avgHours = countWithHours > 0 ? totalHours / countWithHours : 0.0;

    return {
      'total': total,
      'present': present,
      'late': late,
      'absent': absent,
      'leave': leave,
      'halfDay': halfDay,
      'attendanceRate': attendanceRate,
      'punctualityRate': punctualityRate,
      'averageWorkingHours': avgHours,
    };
  }
}
