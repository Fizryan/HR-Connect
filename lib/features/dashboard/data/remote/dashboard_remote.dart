import 'package:hr_connect/core/constants/api_endpoints.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/core/base/base_remote.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';

abstract class DashboardRemote {
  Future<DashboardModel> getDashboardInfo();
}

class DashboardRemoteImpl extends BaseRemote implements DashboardRemote {
  final ApiClient apiClient;

  DashboardRemoteImpl({required this.apiClient});

  @override
  Future<DashboardModel> getDashboardInfo() async {
    return apiCall(() async {
      final response =
          await apiClient.get(ApiEndpoints.dashboard) as Map<String, dynamic>;
      return DashboardModel.fromJson(response);
    });
  }
}
