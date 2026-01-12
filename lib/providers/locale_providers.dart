import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null) {
    _loadLocale();
  }

  static const _kLocaleKey = 'app_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_kLocaleKey);
    if (localeCode != null) {
      state = Locale(localeCode);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_kLocaleKey, locale.languageCode);
    } else {
      await prefs.remove(_kLocaleKey);
    }
  }
}

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) => LocaleController());
















