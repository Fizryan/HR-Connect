import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';
import 'package:hr_connect/features/dashboard/data/remote/dashboard_remote.dart';
import 'package:hr_connect/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepositoryImp extends BaseRepository
    implements DashboardRepository {
  final DashboardRemote remoteDataSource;
  final SharedPreferences sharedPreferences;

  DashboardRepositoryImp({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, DashboardModel>> getDashboardInfo() async {
    final apiResult = await sourceCall(
      () async {
        final data = await remoteDataSource.getDashboardInfo();
        final dataMap = data.toJson();
        await sharedPreferences.setString(
          SharedPrefs.cachedDashboard,
          jsonEncode(dataMap),
        );
        return data;
      },
      Intl.message(
        'Failed to load dashboard information.',
        name: 'loadDashboardInfoFailed',
      ),
    );

    return apiResult.fold(
      (failure) {
        logger.e('[DashboardRepository] API call failed, loading from cache.');
        final cachedData = sharedPreferences.getString(
          SharedPrefs.cachedDashboard,
        );

        if (cachedData != null && cachedData.isNotEmpty) {
          final dataMap = jsonDecode(cachedData) as Map<String, dynamic>;
          return Right(DashboardModel.fromJson(dataMap));
        }

        return Left(failure);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
