import 'package:fpdart/fpdart.dart';
import 'package:hr_connect/core/app_info/data/model/app_info_model.dart';
import 'package:hr_connect/core/error/failures.dart';

abstract class AppInfoRepository {
  Future<Either<Failure, AppInfoModel>> getAppInfo();
}
