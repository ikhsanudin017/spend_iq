import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/app_metadata.dart';
import '../../services/deeplink_service.dart';
import '../../services/notifications_service.dart';
import '../../services/predictive_engine.dart';
import '../../data/datasources/local/boxes.dart';

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.enableMockNetwork,
    required this.supportedForecastDays,
  });

  final String appName;
  final bool enableMockNetwork;
  final List<int> supportedForecastDays;

  AppConfig copyWith({
    String? appName,
    bool? enableMockNetwork,
    List<int>? supportedForecastDays,
  }) =>
      AppConfig(
        appName: appName ?? this.appName,
        enableMockNetwork: enableMockNetwork ?? this.enableMockNetwork,
        supportedForecastDays:
            supportedForecastDays ?? this.supportedForecastDays,
      );
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => const AppConfig(
    appName: 'Spend-IQ',
    enableMockNetwork: true,
    supportedForecastDays: [7, 14, 30],
  ),
);

class AppBootstrapper {
  static bool _initialized = false;
  static bool _firebaseAvailable = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    // Initialize Firebase first (optional - app akan jalan tanpa Firebase)
    try {
      // Check if Firebase is already initialized
      try {
        Firebase.app();
        _firebaseAvailable = true;
        if (kDebugMode) {
          print('✅ Firebase already initialized');
        }
      } catch (_) {
        // Not initialized, try to initialize
        await Firebase.initializeApp();
        _firebaseAvailable = true;
        if (kDebugMode) {
          print('✅ Firebase initialized successfully');
        }
      }
    } catch (e) {
      _firebaseAvailable = false;
      if (kDebugMode) {
        print('⚠️ Firebase initialization failed: $e');
        print('⚠️ Firebase not configured (this is OK for testing)');
        print('App will run without authentication features');
        print('To enable auth, setup Firebase: see QUICK_START_FIREBASE.md');
      }
    }

    // Initialize other services dengan error handling
    try {
      await AppMetadata.ensureInitialized();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ AppMetadata init failed: $e');
      }
    }
    
    try {
      await HiveBoxes.ensureInitialized();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ HiveBoxes init failed: $e');
      }
    }
    
    try {
      await NotificationsService.ensureInitialized();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ NotificationsService init failed: $e');
      }
    }
    
    try {
      await DeeplinkService.ensureInitialized();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ DeeplinkService init failed: $e');
      }
    }
    
    try {
      PredictiveEngine.ensureRegistered();
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ PredictiveEngine registration failed: $e');
      }
    }

    _initialized = true;

    if (kDebugMode) {
      // ignore: avoid_print
      print('✅ AppBootstrapper initialized');
    }
  }

  static bool get isFirebaseAvailable => _firebaseAvailable;
}
