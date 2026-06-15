import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/core/config/date_utils.dart';
import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/trip/data/model/trip_model.dart';

abstract class TripRemote {
  Future<List<TripModel>> getTripMe();
  Future<List<TripModel>> getAllTrips();
  Future<List<TripModel>> getPendingTrips();
  Future<TripModel> getTripById(String id);
  Future<void> createTrip(TripData data);
  Future<void> approveTrip(String id);
  Future<void> rejectTrip(String id);
}

class TripRemoteImpl extends BaseRemote implements TripRemote {
  final ApiClient apiClient;

  TripRemoteImpl({required this.apiClient});

  @override
  Future<List<TripModel>> getTripMe({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.businessTripMe, forceRefresh: true)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((trip) => TripModel.fromJson(trip as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<TripModel>> getAllTrips({bool forceRefresh = false}) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.businessTrips, forceRefresh: true)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((trip) => TripModel.fromJson(trip as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<List<TripModel>> getPendingTrips() async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.businessTripPendingMe)
              as Map<String, dynamic>;
      return (response['requests'] as List)
          .map((trip) => TripModel.fromJson(trip as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<TripModel> getTripById(String id) async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.businessTrip(id))
              as Map<String, dynamic>;
      return TripModel.fromJson(response['request'] as Map<String, dynamic>);
    });
  }

  @override
  Future<void> createTrip(TripData data) async {
    return apiCall(() async {
      final Map<String, dynamic> payload = {
        'request': {
          'type': data.type,
          'description': data.description,
          'startDate': ApiDateUtils.dateToApiString(data.startDate),
          'endDate': ApiDateUtils.dateToApiString(data.endDate),
        },
      };
      await apiClient.post(ApiEndpoints.createBusinessTrip, data: payload);
    });
  }

  @override
  Future<void> approveTrip(String id) async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.approveBusinessTrip(id));
    });
  }

  @override
  Future<void> rejectTrip(String id) async {
    return apiCall(() async {
      await apiClient.post(ApiEndpoints.rejectBusinessTrip(id));
    });
  }
}
