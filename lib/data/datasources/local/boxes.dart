// ignore_for_file: prefer_expression_function_bodies, strict_raw_type
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/autosave_plan.dart';
import '../../models/goal.dart';

class HiveBoxes {
  static const String _bankConnectionsKey = 'bank_connections';
  static const String _goalsKey = 'goals';
  static const String _autosavePlansKey = 'autosave_plans';
  static const String _settingsKey = 'settings';

  static bool _initialized = false;
  static late Box<List> _goalsBox;
  static late Box<List> _autosavePlansBox;
  static late Box<dynamic> _settingsBox;
  static late Box<List> _bankConnectionsBox;

  static Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    _bankConnectionsBox = await Hive.openBox<List>(_bankConnectionsKey);
    _goalsBox = await Hive.openBox<List>(_goalsKey);
    _autosavePlansBox = await Hive.openBox<List>(_autosavePlansKey);
    _settingsBox = await Hive.openBox<dynamic>(_settingsKey);
    _initialized = true;
  }

  static List<String> getConnectedBanks() {
    final data =
        _bankConnectionsBox.get('items', defaultValue: const <String>[]) ??
            <String>[];
    return List<String>.from(data);
  }

  static Future<void> saveConnectedBanks(List<String> banks) {
    return _bankConnectionsBox.put('items', List<String>.from(banks));
  }

  static List<GoalModel> getGoals() {
    final data =
        _goalsBox.get('items', defaultValue: const <Map<String, dynamic>>[]) ??
            <Map<String, dynamic>>[];
    return data
        .map((item) => GoalModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<void> saveGoals(List<GoalModel> goals) {
    final payload = goals.map((goal) => goal.toJson()).toList();
    return _goalsBox.put('items', payload);
  }

  static List<AutosavePlanModel> getAutosavePlans() {
    final data = _autosavePlansBox
            .get('items', defaultValue: const <Map<String, dynamic>>[]) ??
        <Map<String, dynamic>>[];
    return data
        .map(
          (item) => AutosavePlanModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  static Future<void> saveAutosavePlans(List<AutosavePlanModel> plans) {
    final payload = plans.map((plan) => plan.toJson()).toList();
    return _autosavePlansBox.put('items', payload);
  }

  static bool getAutoSaveEnabled() {
    return _settingsBox.get('autosave_enabled', defaultValue: false) as bool;
  }

  static Future<void> setAutoSaveEnabled(bool value) {
    return _settingsBox.put('autosave_enabled', value);
  }

  static bool getSeeded() {
    return _settingsBox.get('seeded', defaultValue: false) as bool;
  }

  static Future<void> setSeeded(bool value) {
    return _settingsBox.put('seeded', value);
  }
}
