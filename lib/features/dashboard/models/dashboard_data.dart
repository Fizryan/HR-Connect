class DashboardData {
  final int totalEmployees;
  final int activeCount;
  final int inactiveCount;
  final List<Map<String, dynamic>> recentEmployees;

  final int todayAttendance;
  final int todayAbsent;
  final int todayLate;
  final int pendingLeaveRequests;
  final int approvedLeaveToday;
  final int totalLeaveThisMonth;
  final DateTime? lastUpdated;

  DashboardData({
    required this.totalEmployees,
    required this.activeCount,
    required this.inactiveCount,
    required this.recentEmployees,
    this.todayAttendance = 0,
    this.todayAbsent = 0,
    this.todayLate = 0,
    this.pendingLeaveRequests = 0,
    this.approvedLeaveToday = 0,
    this.totalLeaveThisMonth = 0,
    this.lastUpdated,
  });

  double get attendanceRate {
    if (totalEmployees == 0) return 0;
    return (todayAttendance / totalEmployees) * 100;
  }

  double get leaveRate {
    if (totalEmployees == 0) return 0;
    return (totalLeaveThisMonth / totalEmployees) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEmployees': totalEmployees,
      'activeCount': activeCount,
      'inactiveCount': inactiveCount,
      'recentEmployees': recentEmployees.map((e) {
        final map = Map<String, dynamic>.from(e);
        if (map['createdAt'] != null) {
          map['createdAt'] = map['createdAt'].toString();
        }
        return map;
      }).toList(),
      'todayAttendance': todayAttendance,
      'todayAbsent': todayAbsent,
      'todayLate': todayLate,
      'pendingLeaveRequests': pendingLeaveRequests,
      'approvedLeaveToday': approvedLeaveToday,
      'totalLeaveThisMonth': totalLeaveThisMonth,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalEmployees: json['totalEmployees'] as int? ?? 0,
      activeCount: json['activeCount'] as int? ?? 0,
      inactiveCount: json['inactiveCount'] as int? ?? 0,
      recentEmployees:
          (json['recentEmployees'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      todayAttendance: json['todayAttendance'] as int? ?? 0,
      todayAbsent: json['todayAbsent'] as int? ?? 0,
      todayLate: json['todayLate'] as int? ?? 0,
      pendingLeaveRequests: json['pendingLeaveRequests'] as int? ?? 0,
      approvedLeaveToday: json['approvedLeaveToday'] as int? ?? 0,
      totalLeaveThisMonth: json['totalLeaveThisMonth'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
    );
  }

  DashboardData copyWith({
    int? totalEmployees,
    int? activeCount,
    int? inactiveCount,
    List<Map<String, dynamic>>? recentEmployees,
    int? todayAttendance,
    int? todayAbsent,
    int? todayLate,
    int? pendingLeaveRequests,
    int? approvedLeaveToday,
    int? totalLeaveThisMonth,
    DateTime? lastUpdated,
  }) {
    return DashboardData(
      totalEmployees: totalEmployees ?? this.totalEmployees,
      activeCount: activeCount ?? this.activeCount,
      inactiveCount: inactiveCount ?? this.inactiveCount,
      recentEmployees: recentEmployees ?? this.recentEmployees,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      todayAbsent: todayAbsent ?? this.todayAbsent,
      todayLate: todayLate ?? this.todayLate,
      pendingLeaveRequests: pendingLeaveRequests ?? this.pendingLeaveRequests,
      approvedLeaveToday: approvedLeaveToday ?? this.approvedLeaveToday,
      totalLeaveThisMonth: totalLeaveThisMonth ?? this.totalLeaveThisMonth,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
