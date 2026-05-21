import 'package:hr_connect/core/const/api_endpoints.dart';
import 'package:hr_connect/core/error/exception.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardRemote {
  Future<DashboardModel> getDashboard();
}

class DashboardRemoteImp implements DashboardRemote {
  final ApiClient apiClient;

  DashboardRemoteImp({required this.apiClient});

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
  Future<DashboardModel> getDashboard() async {
    return _apiCall(() async {
      final response = await apiClient.get(ApiEndpoints.dashboard) as Map<String, dynamic>;
      return DashboardModel.fromJson(response);
    });
  }
}
