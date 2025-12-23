import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/features/dashboard/models/dashboard_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DashboardController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();

  DashboardData? _cachedData;
  DateTime? _lastFetchTime;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _errorMessage;
  static const Duration _cacheDuration = Duration(minutes: 5);
  static const String _cacheKey = 'cached_dashboard_data';

  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get errorMessage => _errorMessage;
  DashboardData? get cachedData => _cachedData;

  bool _isDisposed = false;

  void _safeNotify() {
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

  bool get _isCacheValid {
    if (_cachedData == null || _lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _cacheDuration;
  }

  void clearCache() {
    if (_isDisposed) return;
    _cachedData = null;
    _lastFetchTime = null;
    _safeNotify();
  }

  void clearError() {
    _errorMessage = null;
    _safeNotify();
  }

  Future<void> _saveCacheToStorage() async {
    if (_cachedData == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheEntry = {
        'data': _cachedData!.toJson(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_cacheKey, jsonEncode(cacheEntry));
    } catch (e) {
      debugPrint('Error saving dashboard cache: $e');
    }
  }

  Future<DashboardData?> _loadCacheFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached == null) return null;

      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      final timestamp = DateTime.parse(decoded['timestamp'] as String);

      if (DateTime.now().difference(timestamp) > const Duration(hours: 24)) {
        return null;
      }

      return DashboardData.fromJson(decoded['data'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error loading dashboard cache: $e');
      return null;
    }
  }

  Future<DashboardData> fetchDashboardData({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      return _cachedData!;
    }

    _isLoading = true;
    _errorMessage = null;
    _safeNotify();

    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));
      final monthStart = DateTime(now.year, now.month, 1);

      final results = await Future.wait([
        _firestore.collection('employees').count().get(),
        _firestore
            .collection('employees')
            .where('isActive', isEqualTo: true)
            .count()
            .get(),
        _firestore
            .collection('employees')
            .where('isActive', isEqualTo: false)
            .count()
            .get(),
        _firestore
            .collection('employees')
            .orderBy('createdAt', descending: true)
            .limit(5)
            .get(),
        _firestore
            .collection('attendance')
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
            )
            .where('date', isLessThan: Timestamp.fromDate(todayEnd))
            .get(),
        _firestore
            .collection('leaves')
            .where('status', isEqualTo: 'pending')
            .count()
            .get(),
        _firestore
            .collection('leaves')
            .where('status', isEqualTo: 'approved')
            .get(),
      ]).timeout(const Duration(seconds: 15));

      if (_isDisposed) return _cachedData ?? _getEmptyData();

      final totalEmployees = (results[0] as AggregateQuerySnapshot).count ?? 0;
      final activeCount = (results[1] as AggregateQuerySnapshot).count ?? 0;
      final inactiveCount = (results[2] as AggregateQuerySnapshot).count ?? 0;
      final recentSnapshot = results[3] as QuerySnapshot;
      final attendanceSnapshot = results[4] as QuerySnapshot;
      final pendingLeaveCount =
          (results[5] as AggregateQuerySnapshot).count ?? 0;
      final approvedLeavesSnapshot = results[6] as QuerySnapshot;

      final monthlyLeaveCount = approvedLeavesSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt == null) return false;
        return createdAt.isAfter(
          monthStart.subtract(const Duration(seconds: 1)),
        );
      }).length;

      final recentEmployees = recentSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      }).toList();

      int presentCount = 0;
      int absentCount = 0;
      int lateCount = 0;
      for (final doc in attendanceSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String? ?? '';
        if (status == 'present') {
          presentCount++;
        } else if (status == 'absent') {
          absentCount++;
        } else if (status == 'late') {
          lateCount++;
        }
      }

      final dashboardData = DashboardData(
        totalEmployees: totalEmployees,
        activeCount: activeCount,
        inactiveCount: inactiveCount,
        recentEmployees: recentEmployees,
        todayAttendance: presentCount + lateCount,
        todayAbsent: absentCount,
        todayLate: lateCount,
        pendingLeaveRequests: pendingLeaveCount,
        totalLeaveThisMonth: monthlyLeaveCount,
        lastUpdated: DateTime.now(),
      );

      _cachedData = dashboardData;
      _lastFetchTime = DateTime.now();
      _isLoading = false;
      _isOffline = false;
      await _saveCacheToStorage();
      _safeNotify();

      return dashboardData;
    } on SocketException {
      return await _handleOfflineState();
    } on TimeoutException {
      return await _handleOfflineState();
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
      if (!_isDisposed) {
        _isLoading = false;
        _errorMessage = 'Failed to load dashboard data. Please try again.';
        _safeNotify();
      }

      final cached = await _loadCacheFromStorage();
      if (cached != null) {
        _cachedData = cached;
        _isOffline = true;
        _safeNotify();
        return cached;
      }

      return _getEmptyData();
    }
  }

  Future<DashboardData> _handleOfflineState() async {
    _isOffline = true;
    _isLoading = false;
    _errorMessage = 'No internet connection. Showing cached data.';

    final cached = await _loadCacheFromStorage();
    if (cached != null) {
      _cachedData = cached;
      _safeNotify();
      return cached;
    }

    final emptyData = _getEmptyData();
    _cachedData = emptyData;
    _safeNotify();
    return emptyData;
  }

  DashboardData _getEmptyData() {
    return DashboardData(
      totalEmployees: 0,
      activeCount: 0,
      inactiveCount: 0,
      recentEmployees: [],
      todayAttendance: 0,
      todayAbsent: 0,
      todayLate: 0,
      pendingLeaveRequests: 0,
      totalLeaveThisMonth: 0,
      lastUpdated: DateTime.now(),
    );
  }
}
