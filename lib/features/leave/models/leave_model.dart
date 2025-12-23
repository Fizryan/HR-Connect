import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';

enum LeaveType { annual, sick, personal, maternity, paternity, unpaid }

enum LeaveStatus { pending, approved, rejected, cancelled }

class LeaveModel {
  final String id;
  final String uid;
  final String employeeName;
  final UserRole requesterRole;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime createdAt;

  LeaveModel({
    required this.id,
    required this.uid,
    required this.employeeName,
    this.requesterRole = UserRole.employee,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  int get days => endDate.difference(startDate).inDays + 1;

  bool canBeApprovedBy(UserRole approverRole) {
    switch (requesterRole) {
      case UserRole.employee:
        return approverRole == UserRole.supervisor ||
            approverRole == UserRole.hrd ||
            approverRole == UserRole.admin;
      case UserRole.supervisor:
      case UserRole.finance:
      case UserRole.admin:
        return approverRole == UserRole.hrd;
      case UserRole.hrd:
        return approverRole == UserRole.admin;
    }
  }

  String get requiredApproverText {
    switch (requesterRole) {
      case UserRole.employee:
        return 'Supervisor';
      case UserRole.supervisor:
      case UserRole.finance:
      case UserRole.admin:
        return 'HRD';
      case UserRole.hrd:
        return 'Admin';
    }
  }

  String get typeText {
    switch (type) {
      case LeaveType.annual:
        return 'Annual Leave';
      case LeaveType.sick:
        return 'Sick Leave';
      case LeaveType.personal:
        return 'Personal Leave';
      case LeaveType.maternity:
        return 'Maternity Leave';
      case LeaveType.paternity:
        return 'Paternity Leave';
      case LeaveType.unpaid:
        return 'Unpaid Leave';
    }
  }

  String get statusText {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      employeeName: map['employeeName'] ?? '',
      requesterRole: UserRole.values.firstWhere(
        (e) => e.name == map['requesterRole'],
        orElse: () => UserRole.employee,
      ),
      type: LeaveType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => LeaveType.annual,
      ),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      reason: map['reason'] ?? '',
      status: LeaveStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => LeaveStatus.pending,
      ),
      approvedBy: map['approvedBy'],
      approvedAt: map['approvedAt'] != null
          ? (map['approvedAt'] as Timestamp).toDate()
          : null,
      rejectionReason: map['rejectionReason'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'employeeName': employeeName,
      'requesterRole': requesterRole.name,
      'type': type.name,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'reason': reason,
      'status': status.name,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'rejectionReason': rejectionReason,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  LeaveModel copyWith({
    String? id,
    String? uid,
    String? employeeName,
    UserRole? requesterRole,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    LeaveStatus? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
    DateTime? createdAt,
  }) {
    return LeaveModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      employeeName: employeeName ?? this.employeeName,
      requesterRole: requesterRole ?? this.requesterRole,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
