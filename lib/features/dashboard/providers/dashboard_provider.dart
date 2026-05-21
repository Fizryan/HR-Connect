import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';

final dashboardNotifierProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardModel?>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardModel?> {
  DateTime? lastFetchTime;

  @override
  FutureOr<DashboardModel?> build() async {
    final data = await _fetchDashboardLogic();
    lastFetchTime = DateTime.now();
    return data;
  }

  Future<DashboardModel?> _fetchDashboardLogic() async {
    final repository = ref.read(dashboardRepositoryProvider);
    final result = await repository.getDashboard();

    return result.fold(
      (failure) => throw failure.message,
      (dashboard) => dashboard,
    );
  }

  Future<void> fetchDashboard() async {
    if (state.isLoading) return;

    final isCacheValid =
        lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!).inMinutes < 15;

    if (isCacheValid && state.hasValue) {
      return;
    }

    await refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchDashboardLogic);
    if (state.hasValue) {
      lastFetchTime = DateTime.now();
    }
  }
}
