import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';

class DeeplinkService {
  DeeplinkService._();

  static bool _initialized = false;
  static StreamController<Uri>? _controller;

  static Future<void> ensureInitialized() async {
    _controller ??= StreamController<Uri>.broadcast();
    if (_initialized) {
      return;
    }
    _initialized = true;
  }

  static Stream<Uri> get stream {
    _controller ??= StreamController<Uri>.broadcast();
    return _controller!.stream;
  }

  static void handle(Uri uri, GoRouter router) {
    if (uri.scheme != 'smartspend') {
      return;
    }
    _controller?.add(uri);
    switch (uri.host) {
      case 'alert':
        router.go('${AppRoute.alerts.path}?id=${uri.pathSegments.last}');
        break;
      case 'goal':
        router.go('${AppRoute.goals.path}?id=${uri.pathSegments.last}');
        break;
      default:
        router.go(AppRoute.home.path);
    }
  }

  static Future<void> dispose() async {
    if (_controller != null && !_controller!.isClosed) {
      await _controller!.close();
    }
    _controller = null;
    _initialized = false;
  }
}

final deeplinkServiceProvider = Provider<Stream<Uri>>((ref) {
  ref.onDispose(DeeplinkService.dispose);
  return DeeplinkService.stream;
});
