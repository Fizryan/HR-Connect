import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheManager {
  Future<void> clearAllUserData();
}

class CacheManagerImpl implements CacheManager {
  final SharedPreferences sharedPreferences;
  final _logger = LoggerConfig.logger;

  CacheManagerImpl({required this.sharedPreferences});

  @override
  Future<void> clearAllUserData() async {
    try {
      final keysToRemove = [
        SharedPrefs.cachedUser,
        SharedPrefs.cachedDashboard,
        SharedPrefs.cachedLeaves,
        SharedPrefs.cachedTrips,
        SharedPrefs.cachedAttendance,
      ];

      for (final key in keysToRemove) {
        await sharedPreferences.remove(key);
      }

      _logger.i('[CacheManager] All user local data has been cleared.');
    } catch (e, stackTrace) {
      _logger.e(
        '[CacheManager] Error clearing cache',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
