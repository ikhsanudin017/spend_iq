import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'providers/theme_providers.dart';
import 'providers/locale_providers.dart';

class SmartSpendApp extends ConsumerWidget {
  const SmartSpendApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final config = ref.watch(appConfigProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: themeMode,
      routerConfig: router,
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
