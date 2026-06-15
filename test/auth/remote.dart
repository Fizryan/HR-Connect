import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/network/api_client.dart';
import 'package:hr_connect/features/auth/data/model/auth_model.dart';
import 'package:hr_connect/features/auth/data/remote/auth_remote.dart';
import 'package:hr_connect/features/dashboard/data/model/dashboard_model.dart';
import 'package:hr_connect/features/dashboard/data/remote/dashboard_remote.dart';
import 'package:hr_connect/features/leave/data/model/leave_model.dart';
import 'package:hr_connect/features/leave/data/remote/leave_remote.dart';
import 'package:hr_connect/features/user_management/data/model/user_model.dart';
import 'package:hr_connect/features/user_management/data/remote/user_remote.dart';

void main() {
  late ApiClient apiClient;
  late AuthRemoteImpl authRemote;
  late UserRemoteImpl userRemote;
  late DashboardRemoteImpl dashboardRemote;
  late LeaveRemoteImpl leaveRemote;
  String? savedRefreshToken;

  final logger = LoggerConfig.logger;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: '.env');

    HttpOverrides.global = null;

    FlutterSecureStorage.setMockInitialValues({});

    const secureStorage = FlutterSecureStorage();

    apiClient = ApiClient(secureStorage: secureStorage);
    authRemote = AuthRemoteImpl(apiClient: apiClient);
    userRemote = UserRemoteImpl(apiClient: apiClient);
    dashboardRemote = DashboardRemoteImpl(apiClient: apiClient);
    leaveRemote = LeaveRemoteImpl(apiClient: apiClient);
  });

  group('Integration Testing Authentication AuthRemote', () {
    const testEmail = 'admin@hrconnect.org';
    const testPassword = 'Admin@123';

    test('Login', () async {
      final result = await authRemote.login(testEmail, testPassword);
      expect(result, isA<AuthModel>());

      result.when(
        success: (accessToken, refreshToken, expTime) async {
          expect(accessToken, isNotNull);
          expect(accessToken, isNotEmpty);
          expect(refreshToken, isNotNull);
          expect(refreshToken, isNotEmpty);

          savedRefreshToken = refreshToken;

          apiClient.updateToken(accessToken);

          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'accessToken', value: accessToken);
          await secureStorage.write(key: 'refreshToken', value: refreshToken);
          await secureStorage.write(key: 'expTime', value: expTime.toString());
        },
        error: (message) {
          fail('Test failed because login failed: $message');
        },
      );
    });

    test('GetProfile', () async {
      final result = await userRemote.getUserInfo();
      expect(result, isA<UserModel>());
      expect(result.data.email, testEmail);
      expect(result.isActive, isTrue);
      expect(result.data.firstName, isNotEmpty);
      expect(result.data.role, isNotEmpty);

      logger.i(result);
    });

    test('RefreshToken', () async {
      expect(savedRefreshToken, isNotNull, reason: 'Refresh token not found');

      final result = await authRemote.refreshToken(savedRefreshToken!);

      expect(result, isA<AuthModel>());

      result.when(
        success: (accessToken, refreshToken, expTime) {
          expect(accessToken, isNotNull);
          expect(accessToken, isNotEmpty);
        },
        error: (message) {
          fail('Test failed because refresh token failed: $message');
        },
      );
    });

    test('dashboardData', () async {
      final result = await dashboardRemote.getDashboardInfo();
      logger.i(result);
      expect(result, isA<DashboardModel>());
    });

    test('leaveMe', () async {
      final result = await leaveRemote.getLeaveMe();
      logger.i(result);
      expect(result, isA<List<LeaveModel>>());
    });

    test('leaveGetAllLeaves', () async {
      final result = await leaveRemote.getAllLeaves();
      logger.i(result);
      expect(result, isA<List<LeaveModel>>());
    });

    test('leaveGetPendingLeaves', () async {
      final result = await leaveRemote.getPendingLeaves();
      logger.i(result);
      expect(result, isA<List<LeaveModel>>());
    });
  });
}
