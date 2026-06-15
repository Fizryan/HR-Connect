import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/config/logger_config.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final logger = LoggerConfig.logger;
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: '.env');
      final sharedPreferences = await SharedPreferences.getInstance();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        logger.e('[FlutterError]: ${details.exception}');
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        logger.e('[PlatformDispatcherError]: $error');
        logger.e('[StackTrace]: $stack');
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MainApp(),
        ),
      );
    },
    (error, stack) {
      logger.e('[RunZonedGuardedError]: $error');
      logger.e('[StackTrace]: $stack');
    },
  );
}
