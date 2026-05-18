import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/datasource/auth_remote.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository.dart';
import 'package:hr_connect/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:hr_connect/features/business_trip/data/datasource/business_trip_remote.dart';
import 'package:hr_connect/features/business_trip/data/repositories/business_trip_repository.dart';
import 'package:hr_connect/features/business_trip/data/repositories/business_trip_repository_imp.dart';
import 'package:hr_connect/features/leave/data/datasource/leave_request_remote.dart';
import 'package:hr_connect/features/leave/data/repositories/leave_repository.dart';
import 'package:hr_connect/features/leave/data/repositories/leave_repository_imp.dart';
import 'package:hr_connect/features/user_management/data/datasource/user_remote.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository.dart';
import 'package:hr_connect/features/user_management/data/repositories/user_repository_imp.dart';
import 'package:hr_connect/core/theme/theme_provider.dart';

export 'package:hr_connect/core/theme/theme_provider.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage: secureStorage);
});

final authRemoteProvider = Provider<AuthRemote>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteImpl(apiClient: apiClient);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImp(
    remoteDataSource: ref.watch(authRemoteProvider),
    secureStorage: ref.watch(secureStorageProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    apiClient: ref.watch(apiClientProvider),
  );
});

final userRemoteProvider = Provider<UserRemote>((ref) {
  return UserRemoteImp(apiClient: ref.watch(apiClientProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImp(remoteDataSource: ref.watch(userRemoteProvider));
});

final leaveRemoteProvider = Provider<LeaveRequestRemote>((ref) {
  return LeaveRequestRemoteImp(apiClient: ref.watch(apiClientProvider));
});

final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepositoryImp(remoteDataSource: ref.watch(leaveRemoteProvider));
});

final businessTripProvider = Provider<BusinessTripRemote>((ref) {
  return BusinessTripRemoteImp(apiclient: ref.watch(apiClientProvider));
});

final businessRepositoryProvider = Provider<BusinessTripRepository>((ref) {
  return BusinessTripRepositoryImp(
    remoteDataSource: ref.watch(businessTripProvider),
  );
});
