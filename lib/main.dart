import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/injection.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      await dotenv.load(fileName: ".env");

      await initDI();

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        debugPrint('[FlutterError]: ${details.exception}');
        if (details.stack != null) {
          debugPrint('[StackTrace]: ${details.stack}');
        }
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        debugPrint('[PlatformDispatcherError]: $error');
        debugPrint('[StackTrace]: $stack');
        return true;
      };

      runApp(const MainApp());
    },
    (error, stackTrace) {
      debugPrint('[ZonedGuardedError]: $error');
      debugPrint('[StackTrace]: $stackTrace');
    },
  );
}
