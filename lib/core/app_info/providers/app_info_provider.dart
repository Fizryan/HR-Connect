import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/app_info/data/model/app_info_model.dart';
import 'package:hr_connect/core/di/providers.dart';

final appInfoNotifierProvider =
    AsyncNotifierProvider<AppInfoNotifier, AppInfoModel>(AppInfoNotifier.new);

class AppInfoNotifier extends AsyncNotifier<AppInfoModel> {
  @override
  FutureOr<AppInfoModel> build() async {
    final data = await _fetchAppInfoLogic();
    return data;
  }

  Future<AppInfoModel> _fetchAppInfoLogic() async {
    final repository = ref.read(appInfoRepositoryProvider);
    final result = await repository.getAppInfo();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (appInfo) => appInfo,
    );
  }
}
