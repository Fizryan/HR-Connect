import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/app_info/data/model/app_info_model.dart';
import 'package:hr_connect/core/app_info/data/remote/app_info_remote.dart';
import 'package:hr_connect/core/app_info/data/repositories/app_info_repository.dart';
import 'package:hr_connect/core/base/base_repository.dart';
import 'package:hr_connect/core/error/failures.dart';
import 'package:intl/intl.dart';

class AppInfoRepositoryImp extends BaseRepository implements AppInfoRepository {
  final AppInfoRemote remoteDataSource;

  AppInfoRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, AppInfoModel>> getAppInfo() async {
    return sourceCall(
      remoteDataSource.getAppInfo,
      Intl.message('Failed to load app info.', name: 'loadAppInfoFailed'),
    );
  }
}
