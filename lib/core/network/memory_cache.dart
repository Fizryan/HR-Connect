import 'package:hr_connect/core/network/cache_entry.dart';

class MemoryCache {
  final Map<String, CacheEntry> _cache = {};

  dynamic get(String key) {
    final item = _cache[key];

    if (item == null) return null;

    if (item.isExpired) {
      _cache.remove(key);
      return null;
    }

    return item.data;
  }

  void set(String key, dynamic data, Duration ttl) {
    _cache[key] = CacheEntry(data: data, expiresAt: DateTime.now().add(ttl));
  }

  void clear() {
    _cache.clear();
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void invalidateByPrefix(String prefix) {
    _cache.removeWhere((key, value) => key.startsWith(prefix));
  }
}
