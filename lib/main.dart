import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app dengan error handling
  try {
    await AppBootstrapper.initialize();
  } catch (e, stackTrace) {
    // Log error tapi tetap jalankan app
    debugPrint('⚠️ App initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
  }
  
  // Run app
  runApp(const ProviderScope(child: SmartSpendApp()));
}
