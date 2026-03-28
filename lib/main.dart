import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hr_connect/app.dart';
import 'package:hr_connect/core/di/injection.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await initDI();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      // TODO: Firebase Crash UI
      debugPrint('[UI ERROR]: ${details.exception}');
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      // TODO: Firebase Crash Logic
      debugPrint('[APP ERROR]: $error');
      return true;
    };

    runApp(const MainApp());
  }, (error, stackTrace) {
    debugPrint('[APP ERROR]: $error');
  });
}