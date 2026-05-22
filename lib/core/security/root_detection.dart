import 'dart:io';
import 'package:flutter/foundation.dart';

/// Root / Jailbreak Detection
/// Detect compromised devices for security
class RootDetection {
  RootDetection._();

  /// Check if device is rooted (Android) or jailbroken (iOS)
  static Future<bool> isCompromised() async {
    if (kDebugMode) return false; // Skip in debug mode

    if (Platform.isAndroid) {
      return _checkAndroidRoot();
    } else if (Platform.isIOS) {
      return _checkIOSJailbreak();
    }
    return false;
  }

  static Future<bool> _checkAndroidRoot() async {
    try {
      // Check for common root indicators
      final rootPaths = [
        '/system/app/Superuser.apk',
        '/system/xbin/su',
        '/system/bin/su',
        '/sbin/su',
        '/data/local/xbin/su',
        '/data/local/bin/su',
        '/data/local/su',
        '/su/bin/su',
      ];

      for (final path in rootPaths) {
        if (await File(path).exists()) return true;
      }

      // In production, use platform channels to check installed packages

      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _checkIOSJailbreak() async {
    try {
      final jailbreakPaths = [
        '/Applications/Cydia.app',
        '/Library/MobileSubstrate/MobileSubstrate.dylib',
        '/bin/bash',
        '/usr/sbin/sshd',
        '/etc/apt',
        '/private/var/lib/apt/',
      ];

      for (final path in jailbreakPaths) {
        if (await File(path).exists()) return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }
}
