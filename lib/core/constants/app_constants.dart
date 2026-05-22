/// Colony App Constants
/// Central place for all app-wide constants
class AppConstants {
  AppConstants._();

  // ─── App Info ───────────────────────────────────────────────
  static const String appName = 'Colony';
  static const String appTagline = 'Your neighborhood, connected';
  static const String appVersion = '1.0.0';

  // ─── Pagination ─────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  static const int chatPageSize = 30;
  static const int storyPageSize = 10;

  // ─── Timeouts ───────────────────────────────────────────────
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
  static const int sendTimeoutMs = 10000;

  // ─── Location ───────────────────────────────────────────────
  static const double defaultLatitude = 28.6139; // Delhi
  static const double defaultLongitude = 77.2090;
  static const double defaultRadiusKm = 5.0;
  static const double maxRadiusKm = 50.0;
  static const double minRadiusKm = 0.5;
  static const int geohashPrecision = 6;

  // ─── Media Limits ───────────────────────────────────────────
  static const int maxImageSizeMb = 10;
  static const int maxVideoSizeMb = 50;
  static const int maxVideoDurationSec = 60;
  static const int maxStoryDurationSec = 15;
  static const int maxImagesPerPost = 10;
  static const int imageQuality = 85;

  // ─── Chat Limits ────────────────────────────────────────────
  static const int maxMessageLength = 4000;
  static const int maxGroupMembers = 256;
  static const int maxGroupNameLength = 50;

  // ─── Profile Limits ─────────────────────────────────────────
  static const int maxBioLength = 150;
  static const int maxDisplayNameLength = 30;
  static const int maxUsernameLength = 20;
  static const int minUsernameLength = 3;

  // ─── Radar ──────────────────────────────────────────────────
  static const int radarRefreshIntervalSec = 30;
  static const int maxRadarUsers = 100;
  static const double radarAnimationDurationMs = 800;

  // ─── Stories ────────────────────────────────────────────────
  static const int storyExpiryHours = 24;
  static const int maxStoriesPerDay = 15;

  // ─── Coins ──────────────────────────────────────────────────
  static const int coinPerRupe = 10;
  static const int superLikeCoins = 5;
  static const int boostCoins = 20;
  static const int premiumMonthlyCoins = 100;

  // ─── Validation ─────────────────────────────────────────────
  static const String phoneRegex = r'^[6-9]\d{9}$';
  static const String usernameRegex = r'^[a-z0-9_]{3,20}$';
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String otpRegex = r'^\d{6}$';

  // ─── Cache Durations ────────────────────────────────────────
  static const Duration profileCacheDuration = Duration(hours: 1);
  static const Duration feedCacheDuration = Duration(minutes: 15);
  static const Duration configCacheDuration = Duration(hours: 6);
  static const Duration imageCacheDuration = Duration(days: 7);
}
