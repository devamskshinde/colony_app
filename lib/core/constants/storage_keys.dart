/// Hive/Secure Storage Keys
/// Centralized key management for all persisted data
class StorageKeys {
  StorageKeys._();

  // ─── Auth Keys ──────────────────────────────────────────────
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String deviceId = 'device_id';
  static const String isLoggedIn = 'is_logged_in';
  static const String tokenExpiry = 'token_expiry';

  // ─── User Keys ──────────────────────────────────────────────
  static const String userProfile = 'user_profile';
  static const String userName = 'user_name';
  static const String userPhone = 'user_phone';
  static const String userAvatar = 'user_avatar';
  static const String userTier = 'user_tier';

  // ─── Location Keys ──────────────────────────────────────────
  static const String lastLatitude = 'last_latitude';
  static const String lastLongitude = 'last_longitude';
  static const String lastGeohash = 'last_geohash';
  static const String locationPermission = 'location_permission';

  // ─── Settings Keys ──────────────────────────────────────────
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String locationEnabled = 'location_enabled';
  static const String biometricEnabled = 'biometric_enabled';
  static const String radarEnabled = 'radar_enabled';
  static const String discoveryEnabled = 'discovery_enabled';

  // ─── Cache Keys ─────────────────────────────────────────────
  static const String feedCache = 'feed_cache';
  static const String profileCache = 'profile_cache';
  static const String configCache = 'config_cache';
  static const String contactsHash = 'contacts_hash';

  // ─── Onboarding Keys ────────────────────────────────────────
  static const String onboardingComplete = 'onboarding_complete';
  static const String profileComplete = 'profile_complete';
  static const String permissionsRequested = 'permissions_requested';

  // ─── App State Keys ─────────────────────────────────────────
  static const String lastActiveTime = 'last_active_time';
  static const String appOpenCount = 'app_open_count';
  static const String lastNotificationTime = 'last_notification_time';
  static const String fcmToken = 'fcm_token';

  // ─── Hive Box Names ─────────────────────────────────────────
  static const String authBox = 'auth_box';
  static const String userBox = 'user_box';
  static const String cacheBox = 'cache_box';
  static const String settingsBox = 'settings_box';
}
