import 'dart:async';
import 'package:flutter/material.dart';

mixin SafeNotifierMixin on ChangeNotifier {
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  void safeNotify() {
    if (!_isDisposed) {
      Future.microtask(() {
        if (!_isDisposed) notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

abstract class BaseController extends ChangeNotifier with SafeNotifierMixin {
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasData = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _hasData;
  bool get hasError => _errorMessage != null;

  @protected
  void setLoading(bool value) {
    if (isDisposed) return;
    _isLoading = value;
    safeNotify();
  }

  @protected
  void setError(String? message) {
    if (isDisposed) return;
    _errorMessage = message;
    safeNotify();
  }

  @protected
  void setHasData(bool value) {
    if (isDisposed) return;
    _hasData = value;
    safeNotify();
  }

  void clearError() {
    if (isDisposed) return;
    _errorMessage = null;
    safeNotify();
  }

  Future<T?> executeAsync<T>({
    required Future<T> Function() operation,
    String? errorPrefix,
    bool showLoading = true,
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    if (isDisposed) return null;

    if (showLoading) setLoading(true);
    _errorMessage = null;

    try {
      final result = await operation();
      if (!isDisposed) {
        _hasData = true;
        if (showLoading) setLoading(false);
        onSuccess?.call();
      }
      return result;
    } catch (e) {
      final message = errorPrefix != null
          ? '$errorPrefix: ${e.toString()}'
          : e.toString();
      debugPrint('Controller error: $message');

      if (!isDisposed) {
        _errorMessage = message;
        if (showLoading) setLoading(false);
        onError?.call(message);
      }
      return null;
    }
  }
}

mixin FilterableController on ChangeNotifier, SafeNotifierMixin {
  String _currentFilter = 'All';
  String _searchQuery = '';
  Timer? _debounceTimer;

  static const Duration defaultDebounceDuration = Duration(milliseconds: 300);

  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  void setFilter(String filter) {
    if (isDisposed) return;
    _currentFilter = filter;
    safeNotify();
  }

  void setSearchQuery(String query, {Duration? debounceDuration}) {
    if (isDisposed) return;
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration ?? defaultDebounceDuration, () {
      if (!isDisposed) safeNotify();
    });
  }

  void clearFilters() {
    if (isDisposed) return;
    _currentFilter = 'All';
    _searchQuery = '';
    safeNotify();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

mixin PaginatedController on ChangeNotifier, SafeNotifierMixin {
  int _currentPage = 1;
  int _totalPages = 1;
  int _itemsPerPage = 20;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get itemsPerPage => _itemsPerPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  void setPage(int page) {
    if (isDisposed) return;
    _currentPage = page;
    safeNotify();
  }

  void setTotalPages(int total) {
    if (isDisposed) return;
    _totalPages = total;
    _hasMore = _currentPage < _totalPages;
    safeNotify();
  }

  void setItemsPerPage(int count) {
    if (isDisposed) return;
    _itemsPerPage = count;
    safeNotify();
  }

  void setLoadingMore(bool value) {
    if (isDisposed) return;
    _isLoadingMore = value;
    safeNotify();
  }

  void resetPagination() {
    if (isDisposed) return;
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    safeNotify();
  }
}

mixin CacheableController on ChangeNotifier, SafeNotifierMixin {
  DateTime? _lastFetchTime;
  Duration _cacheDuration = const Duration(minutes: 5);

  DateTime? get lastFetchTime => _lastFetchTime;
  Duration get cacheDuration => _cacheDuration;

  bool get isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  void setCacheDuration(Duration duration) {
    _cacheDuration = duration;
  }

  void updateCacheTime() {
    if (isDisposed) return;
    _lastFetchTime = DateTime.now();
  }

  void invalidateCache() {
    if (isDisposed) return;
    _lastFetchTime = null;
    safeNotify();
  }
}
