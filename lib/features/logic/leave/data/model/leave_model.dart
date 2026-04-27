import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';

part 'leave_model.freezed.dart';
part 'leave_model.g.dart';

@freezed
abstract class LeaveModel with _$LeaveModel {
  const factory LeaveModel({
    required String uid,
    required String requestedById,
    String? approvedById,
    required LeaveType type,
    required String reason,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'is_approved', defaultValue: false) required bool isApproved,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LeaveModel;

  factory LeaveModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveModelFromJson(json);
}
