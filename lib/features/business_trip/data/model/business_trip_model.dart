import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_connect/core/const/enums.dart';

part 'business_trip_model.freezed.dart';
part 'business_trip_model.g.dart';

@freezed
abstract class BusinessTripModel with _$BusinessTripModel {
  const BusinessTripModel._();

  const factory BusinessTripModel({
    required String id,
    required String requestId,
    required BusinessTripType businessTripType,
    String? description,
    String? approverId,
    @Default(RequestStatus.pending) RequestStatus status,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BusinessTripModel;

  factory BusinessTripModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessTripModelFromJson(json);

  factory BusinessTripModel.fromApi(Map<String, dynamic> json) {
    final requestNode = json['request'] as Map<String, dynamic>? ?? json;
    final dataNode = requestNode['data'] as Map<String, dynamic>? ?? {};
    final rawBusinessTripType = dataNode['type'] as String? ?? '';
    String mappedBusinessTripType = 'other';

    switch (rawBusinessTripType.toUpperCase()) {
      case 'MEETING':
        mappedBusinessTripType = 'meeting';
        break;
      case 'TRAVEL':
        mappedBusinessTripType = 'travel';
        break;
      case 'CONFERENCE':
        mappedBusinessTripType = 'conference';
        break;
      case 'SEMINAR':
        mappedBusinessTripType = 'seminar';
        break;
      case 'OTHER':
        mappedBusinessTripType = 'other';
        break;
      default:
        mappedBusinessTripType = rawBusinessTripType.toLowerCase();
    }

    return BusinessTripModel.fromJson({
      'id': requestNode['id'] ?? '',
      'requestId': requestNode['id'] ?? '',
      'businessTripType': mappedBusinessTripType,
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