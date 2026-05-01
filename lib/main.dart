import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: '.env');

      final sharedPreferences = await SharedPreferences.getInstance();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint('[FlutterError]: ${details.exception}');
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        debugPrint('[PlatformDispatcherError]: $error');
        debugPrint('[StackTrace]: $stack');
        return true;
      };

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MainApp(),
        )
      );
    },
    (error, stack) {
      debugPrint('[RunZonedGuardedError]: $error');
      debugPrint('[StackTrace]: $stack');
    },
  );
}
