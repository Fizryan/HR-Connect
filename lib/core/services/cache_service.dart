import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveToCache(String key, dynamic data) async {
    await init();
    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _prefs?.setString(key, jsonEncode(cacheEntry));
  }

  Future<T?> getFromCache<T>(
    String key, {
    Duration? maxAge,
    T Function(dynamic)? fromJson,
  }) async {
    await init();
    final cached = _prefs?.getString(key);
    if (cached == null) return null;

    try {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = DateTime.parse(decoded['timestamp'] as String);

      if (maxAge != null) {
        if (DateTime.now().difference(timestamp) > maxAge) {
          await removeFromCache(key);
          return null;
        }
      }

      final data = decoded['data'];
      if (fromJson != null) {
        return fromJson(data);
      }
      return data as T?;
    } catch (e) {
      return null;
    }
  }

  Future<void> removeFromCache(String key) async {
    await init();
    await _prefs?.remove(key);
  }

  Future<void> clearCache() async {
    await init();
    final keys = _prefs?.getKeys() ?? {};
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await _prefs?.remove(key);
      }
    }
  }

  static const String dashboardData = 'cache_dashboard_data';
  static const String attendanceData = 'cache_attendance_data';
  static const String leaveData = 'cache_leave_data';
  static const String userData = 'cache_user_data';
}
