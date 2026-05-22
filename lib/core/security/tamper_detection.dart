import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Tamper Detection
/// Verify app integrity to prevent modified builds
class TamperDetection {
  TamperDetection._();

  static const String _expectedPackageName = 'com.colony.colony_app';

  /// Check if app has been tampered with
  static Future<bool> isTampered() async {
    if (kDebugMode) return false;

    try {
      final info = await PackageInfo.fromPlatform();

      // Verify package name
      if (info.packageName != _expectedPackageName) {
        return true;
      }

      // In production: verify APK signature hash
      // In production: verify checksum of critical files

      return false;
    } catch (_) {
      return true; // Assume tampered if check fails
    }
  }

  /// Get app integrity report
  static Future<Map<String, dynamic>> getIntegrityReport() async {
    final info = await PackageInfo.fromPlatform();

    return {
      'packageName': info.packageName,
      'version': info.version,
      'buildNumber': info.buildNumber,
      'isTampered': await isTampered(),
      'isDebug': kDebugMode,
    };
  }
}
