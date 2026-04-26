import 'package:freezed_annotation/freezed_annotation.dart';

part 'overtime_model.freezed.dart';
part 'overtime_model.g.dart';

@freezed
abstract class OvertimeModel with _$OvertimeModel {
  const factory OvertimeModel({
    required String uid,
    required String requestedById,
    String? approvedById,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'is_approved', defaultValue: false) required bool isApproved,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OvertimeModel;

  factory OvertimeModel.fromJson(Map<String, dynamic> json) =>
      _$OvertimeModelFromJson(json);
}
