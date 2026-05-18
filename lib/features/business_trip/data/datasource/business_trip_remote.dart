import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/business_trip/data/model/business_trip_model.dart';

abstract class BusinessTripRemote {
  Future<List<BusinessTripModel>> getBusinessTrip();
  Future<BusinessTripModel> getBusinessTripById(String id);
  Future<BusinessTripModel> updateBusinessTrip(
    String id,
    Map<String, dynamic> updateData,
  );
  Future<void> deleteBusinessTrip(String id);
  Future<void> approveBusinessTrip(String id);
  Future<void> rejectBusinessTrip(String id);
}

class BusinessTripRemoteImp implements BusinessTripRemote {
  final ApiClient apiclient;

  BusinessTripRemoteImp({required this.apiclient});

  Future<T> _apiCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Something went wrong');
    }
  }

  @override
  Future<List<BusinessTripModel>> getBusinessTrip() async {
    return _apiCall(() async {
      final response = await apiclient.get(ApiEndpoints.businessTrips);
      final List<dynamic> businessTripList = response['trip'] ?? [];
      return businessTripList.map((businessTripJson) {
        return BusinessTripModel.fromApi(
          businessTripJson as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  @override
  Future<BusinessTripModel> getBusinessTripById(String id) async {
    return _apiCall(() async {
      final response = await apiclient.get(ApiEndpoints.businessTrip(id));
      return BusinessTripModel.fromApi(response.data);
    });
  }

  @override
  Future<BusinessTripModel> updateBusinessTrip(
    String id,
    Map<String, dynamic> updateData,
  ) async {
    return _apiCall(() async {
      final response = await apiclient.put(
        ApiEndpoints.putBusinessTrip(id),
        data: updateData,
      );
      return BusinessTripModel.fromApi(response.data);
    });
  }

  @override
  Future<void> deleteBusinessTrip(String id) async {
    return _apiCall(() async {
      await apiclient.delete(ApiEndpoints.deleteBusinessTrip(id));
    });
  }

  @override
  Future<void> approveBusinessTrip(String id) async {
    return _apiCall(() async {
      await apiclient.post(ApiEndpoints.approveBusinessTrip(id));
    });
  }

  @override
  Future<void> rejectBusinessTrip(String id) async {
    return _apiCall(() async {
      await apiclient.post(ApiEndpoints.rejectBusinessTrip(id));
    });
  }
}
