import 'package:cloud_firestore/cloud_firestore.dart';

enum AttendanceStatus { present, absent, late, leave, halfDay }

class AttendanceModel {
  final String id;
  final String uid;
  final String employeeName;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final AttendanceStatus status;
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.uid,
    required this.employeeName,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    this.notes,
  });

  String get statusText {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.leave:
        return 'On Leave';
      case AttendanceStatus.halfDay:
        return 'Half Day';
    }
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      employeeName: map['employeeName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      checkIn: map['checkIn'] != null
          ? (map['checkIn'] as Timestamp).toDate()
          : null,
      checkOut: map['checkOut'] != null
          ? (map['checkOut'] as Timestamp).toDate()
          : null,
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AttendanceStatus.absent,
      ),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'employeeName': employeeName,
      'date': Timestamp.fromDate(date),
      'checkIn': checkIn != null ? Timestamp.fromDate(checkIn!) : null,
      'checkOut': checkOut != null ? Timestamp.fromDate(checkOut!) : null,
      'status': status.name,
      'notes': notes,
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? uid,
    String? employeeName,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    AttendanceStatus? status,
    String? notes,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
