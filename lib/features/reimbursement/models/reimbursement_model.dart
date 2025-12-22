import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_connect/features/auth/models/user_model.dart';

enum ReimbursementType {
  transportation,
  meals,
  accommodation,
  officeSupplies,
  medical,
  training,
  other,
}

enum ReimbursementStatus { pending, approved, rejected, paid }

class ReimbursementModel {
  final String id;
  final String uid;
  final String employeeName;
  final UserRole requesterRole;
  final ReimbursementType type;
  final double amount;
  final String description;
  final String? receiptUrl;
  final DateTime expenseDate;
  final ReimbursementStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DateTime? paidAt;
  final DateTime createdAt;

  ReimbursementModel({
    required this.id,
    required this.uid,
    required this.employeeName,
    required this.requesterRole,
    required this.type,
    required this.amount,
    required this.description,
    this.receiptUrl,
    required this.expenseDate,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    this.paidAt,
    required this.createdAt,
  });

  String get typeText {
    switch (type) {
      case ReimbursementType.transportation:
        return 'Transportation';
      case ReimbursementType.meals:
        return 'Meals & Entertainment';
      case ReimbursementType.accommodation:
        return 'Accommodation';
      case ReimbursementType.officeSupplies:
        return 'Office Supplies';
      case ReimbursementType.medical:
        return 'Medical Expenses';
      case ReimbursementType.training:
        return 'Training & Education';
      case ReimbursementType.other:
        return 'Other';
    }
  }

  String get statusText {
    switch (status) {
      case ReimbursementStatus.pending:
        return 'Pending';
      case ReimbursementStatus.approved:
        return 'Approved';
      case ReimbursementStatus.rejected:
        return 'Rejected';
      case ReimbursementStatus.paid:
        return 'Paid';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'employeeName': employeeName,
      'requesterRole': requesterRole.name,
      'type': type.name,
      'amount': amount,
      'description': description,
      'receiptUrl': receiptUrl,
      'expenseDate': Timestamp.fromDate(expenseDate),
      'status': status.name,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'rejectionReason': rejectionReason,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ReimbursementModel.fromMap(Map<String, dynamic> map) {
    return ReimbursementModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      employeeName: map['employeeName'] ?? '',
      requesterRole: UserRole.values.firstWhere(
        (r) => r.name == map['requesterRole'],
        orElse: () => UserRole.employee,
      ),
      type: ReimbursementType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => ReimbursementType.other,
      ),
      amount: (map['amount'] as num?)?.toDouble() ?? 0,
      description: map['description'] ?? '',
      receiptUrl: map['receiptUrl'],
      expenseDate:
          (map['expenseDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: ReimbursementStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => ReimbursementStatus.pending,
      ),
      approvedBy: map['approvedBy'],
      approvedAt: (map['approvedAt'] as Timestamp?)?.toDate(),
      rejectionReason: map['rejectionReason'],
      paidAt: (map['paidAt'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  ReimbursementModel copyWith({
    String? id,
    String? uid,
    String? employeeName,
    UserRole? requesterRole,
    ReimbursementType? type,
    double? amount,
    String? description,
    String? receiptUrl,
    DateTime? expenseDate,
    ReimbursementStatus? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectionReason,
    DateTime? paidAt,
    DateTime? createdAt,
  }) {
    return ReimbursementModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      employeeName: employeeName ?? this.employeeName,
      requesterRole: requesterRole ?? this.requesterRole,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      expenseDate: expenseDate ?? this.expenseDate,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      paidAt: paidAt ?? this.paidAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
