import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_connect/core/constants/shared_preferences.dart';
import 'package:hr_connect/core/di/providers.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeString = prefs.getString(SharedPrefs.themeMode);

    if (themeString == ThemeMode.light.name) return ThemeMode.light;
    if (themeString == ThemeMode.dark.name) return ThemeMode.dark;
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;

    state = mode;

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(SharedPrefs.themeMode, mode.name);
  }
}

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
