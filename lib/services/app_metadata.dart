import 'package:package_info_plus/package_info_plus.dart';

class AppMetadata {
  AppMetadata._();

  static PackageInfo? _info;

  static Future<void> ensureInitialized() async {
    _info ??= await PackageInfo.fromPlatform();
  }

  static String get version => _info?.version ?? '1.0.0';

  static String get buildNumber => _info?.buildNumber ?? '1';
}
