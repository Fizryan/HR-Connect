import 'package:hr_connect/core/app_info/data/model/app_info_model.dart';
import 'package:hr_connect/core/base/base_remote.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoRemote {
  Future<AppInfoModel> getAppInfo();
}

class AppInfoRemoteImpl extends BaseRemote implements AppInfoRemote {
  @override
  Future<AppInfoModel> getAppInfo() async {
    return apiCall(() async {
      final packageInfo = await PackageInfo.fromPlatform();
      return AppInfoModel(
        appName: packageInfo.appName,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      );
    });
  }
}
