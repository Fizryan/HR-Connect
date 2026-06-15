import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardModel>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardModel> {
  DateTime? lastFetchTime;

  @override
  FutureOr<DashboardModel> build() async {
    final data = await _fetchDashboardLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<DashboardModel> _fetchDashboardLogic() async {
    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.getDashboardInfo();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}
