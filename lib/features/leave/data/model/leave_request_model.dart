import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

@freezed
abstract class LeaveRequestModel with _$LeaveRequestModel {
  const LeaveRequestModel._();

  const factory LeaveRequestModel({
    required String id,
    required String requestId,
    required LeaveType leaveType,
    String? description,
    String? approverId,
    @Default(RequestStatus.pending) RequestStatus status,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LeaveRequestModel;

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);

  factory LeaveRequestModel.fromApi(Map<String, dynamic> json) {
    final requestNode = json['request'] as Map<String, dynamic>? ?? json;
    final dataNode = requestNode['data'] as Map<String, dynamic>? ?? {};
    final rawLeaveType = dataNode['type'] as String? ?? '';
    String mappedLeaveType = 'other';

    switch (rawLeaveType.toUpperCase()) {
      case 'SICK':
        mappedLeaveType = 'sick';
        break;
      case 'CASUAL':
        mappedLeaveType = 'casual';
        break;
      case 'MATERNITY':
        mappedLeaveType = 'maternity';
        break;
      case 'PATERNITY':
        mappedLeaveType = 'paternity';
        break;
      case 'OTHER':
        mappedLeaveType = 'other';
        break;
      default:
        mappedLeaveType = rawLeaveType.toLowerCase();
    }

    return LeaveRequestModel.fromJson({
      'id': requestNode['id'] ?? '',
      'requestId': requestNode['id'] ?? '',
      'leaveType': mappedLeaveType,
      'description': dataNode['description'],
      'approverId': requestNode['approverId'],
      'status': (requestNode['status'] as String?)?.toLowerCase() ?? 'pending',
      'startDate': dataNode['startDate'] ?? DateTime.now().toIso8601String(),
      'endDate': dataNode['endDate'] ?? DateTime.now().toIso8601String(),
      'createdAt': requestNode['createdAt'],
      'updatedAt': requestNode['updatedAt'],
    }); 
  }
}
