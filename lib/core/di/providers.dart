import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_connect/core/app_info/data/remote/app_info_remote.dart';
import 'package:hr_connect/core/app_info/data/repositories/app_info_repository.dart';
import 'package:hr_connect/core/app_info/data/repositories/app_info_repository_imp.dart';
import 'package:hr_connect/core/cache/cache_manager.dart';
import 'package:hr_connect/core/di/features_export_di.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider initiation in main.dart');
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

final cacheManagerProvider = Provider<CacheManager>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return CacheManagerImpl(sharedPreferences: sharedPreferences);
});

final appInfoRemoteProvider = Provider<AppInfoRemote>((ref) {
  return AppInfoRemoteImpl();
});

final appInfoRepositoryProvider = Provider<AppInfoRepository>((ref) {
  return AppInfoRepositoryImp(
    remoteDataSource: ref.watch(appInfoRemoteProvider),
  );
});

final authRemoteProvider = Provider<AuthRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteImpl(apiClient: apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImp(
    remoteDataSource: ref.watch(authRemoteProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final userRemoteProvider = Provider<UserRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteImpl(apiClient: apiClient);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImp(
    remoteDataSource: ref.watch(userRemoteProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final dashboardRemoteProvider = Provider<DashboardRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashboardRemoteImpl(apiClient: apiClient);
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImp(
    remoteDataSource: ref.watch(dashboardRemoteProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final leaveRemoteProvider = Provider<LeaveRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LeaveRemoteImpl(apiClient: apiClient);
});

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImp(
    remoteDataSource: ref.watch(leaveRemoteProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final tripRemoteProvider = Provider<TripRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TripRemoteImpl(apiClient: apiClient);
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImp(
    remoteDataSource: ref.watch(tripRemoteProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});
