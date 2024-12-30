import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/hive_database.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final prefs = HiveDatabase().getPreferences();
    return prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final prefs = HiveDatabase().getPreferences();
    prefs.isDarkMode = !prefs.isDarkMode;
    HiveDatabase().savePreferences(prefs);
    state = prefs.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
