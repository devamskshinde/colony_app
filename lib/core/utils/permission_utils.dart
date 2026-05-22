import 'package:permission_handler/permission_handler.dart';

/// Permission Utilities
/// Handle runtime permissions gracefully
class PermissionUtils {
  PermissionUtils._();

  /// Request location permission
  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Request location always (background)
  static Future<bool> requestLocationAlways() async {
    final status = await Permission.locationAlways.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Request camera permission
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Request photo library permission
  static Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Request notification permission
  static Future<bool> requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Request microphone permission
  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  /// Check if location is granted
  static Future<bool> isLocationGranted() async {
    return (await Permission.location.status).isGranted;
  }

  /// Check if camera is granted
  static Future<bool> isCameraGranted() async {
    return (await Permission.camera.status).isGranted;
  }

  /// Request multiple permissions at once
  static Future<Map<Permission, PermissionStatus>> requestMultiple(
    List<Permission> permissions,
  ) async {
    return await permissions.request();
  }

  /// Check if any permission is permanently denied
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    return (await permission.status).isPermanentlyDenied;
  }
}
