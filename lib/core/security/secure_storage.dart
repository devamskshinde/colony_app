import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

/// Secure Storage Service
/// Wrapper around flutter_secure_storage for sensitive data
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  // ─── Token Management ───────────────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: accessToken),
      _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
      _storage.write(key: StorageKeys.isLoggedIn, value: 'true'),
    ]);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<bool> get isLoggedIn async =>
      (await _storage.read(key: StorageKeys.isLoggedIn)) == 'true';

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.write(key: StorageKeys.isLoggedIn, value: 'false'),
    ]);
  }

  // ─── User Data ──────────────────────────────────────────────
  Future<void> saveUserId(String userId) =>
      _storage.write(key: StorageKeys.userId, value: userId);

  Future<String?> getUserId() => _storage.read(key: StorageKeys.userId);

  Future<void> saveDeviceId(String deviceId) =>
      _storage.write(key: StorageKeys.deviceId, value: deviceId);

  Future<String?> getDeviceId() => _storage.read(key: StorageKeys.deviceId);

  // ─── FCM Token ──────────────────────────────────────────────
  Future<void> saveFcmToken(String token) =>
      _storage.write(key: StorageKeys.fcmToken, value: token);

  Future<String?> getFcmToken() => _storage.read(key: StorageKeys.fcmToken);

  // ─── Generic Operations ─────────────────────────────────────
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> clearAll() => _storage.deleteAll();
}
