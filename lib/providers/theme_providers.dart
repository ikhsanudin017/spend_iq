import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const _kThemeKey = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Default ke light mode (index 0) jika belum ada preference
    final themeIndex = prefs.getInt(_kThemeKey);
    if (themeIndex != null) {
      state = ThemeMode.values[themeIndex];
    } else {
      // First time: set to light mode
      state = ThemeMode.light;
      await prefs.setInt(_kThemeKey, ThemeMode.light.index);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeKey, mode.index);
  }

  Future<void> toggleTheme() async =>
      setTheme(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>((ref) => ThemeController());


