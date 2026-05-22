/// Colony API Constants
/// All API endpoints and related constants
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ──────────────────────────────────────────────
  static const String baseUrl = 'https://api.colonyapp.in/v1';
  static const String wsUrl = 'wss://ws.colonyapp.in';
  static const String cdnUrl = 'https://cdn.colonyapp.in';
  static const String socketUrl = 'https://socket.colonyapp.in';

  // ─── Auth Endpoints ─────────────────────────────────────────
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String deleteAccount = '/auth/delete-account';

  // ─── User Endpoints ─────────────────────────────────────────
  static const String profile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String uploadAvatar = '/users/avatar';
  static const String getUser = '/users/';
  static const String blockUser = '/users/block';
  static const String reportUser = '/users/report';

  // ─── Feed Endpoints ─────────────────────────────────────────
  static const String feed = '/feed';
  static const String createPost = '/posts';
  static const String deletePost = '/posts/';
  static const String likePost = '/posts/like';
  static const String commentPost = '/posts/comment';
  static const String sharePost = '/posts/share';

  // ─── Stories Endpoints ──────────────────────────────────────
  static const String stories = '/stories';
  static const String createStory = '/stories';
  static const String viewStory = '/stories/view';
  static const String deleteStory = '/stories/';

  // ─── Chat Endpoints ─────────────────────────────────────────
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/messages';
  static const String sendMessage = '/chat/messages';
  static const String markRead = '/chat/mark-read';

  // ─── Group Endpoints ────────────────────────────────────────
  static const String groups = '/groups';
  static const String createGroup = '/groups';
  static const String joinGroup = '/groups/join';
  static const String leaveGroup = '/groups/leave';

  // ─── Radar Endpoints ────────────────────────────────────────
  static const String radarUsers = '/radar/users';
  static const String radarPing = '/radar/ping';
  static const String updateLocation = '/location/update';

  // ─── Discovery Endpoints ────────────────────────────────────
  static const String discover = '/discover';
  static const String trending = '/discover/trending';
  static const String nearby = '/discover/nearby';
  static const String recommendations = '/discover/recommendations';

  // ─── Notification Endpoints ─────────────────────────────────
  static const String notifications = '/notifications';
  static const String markNotificationRead = '/notifications/read';
  static const String updateFcmToken = '/notifications/fcm-token';

  // ─── Settings Endpoints ─────────────────────────────────────
  static const String settings = '/settings';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';

  // ─── Report Endpoints ───────────────────────────────────────
  static const String report = '/reports';
  static const String reportContent = '/reports/content';

  // ─── Admin Endpoints ────────────────────────────────────────
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminReports = '/admin/reports';
  static const String adminAnalytics = '/admin/analytics';

  // ─── Headers ────────────────────────────────────────────────
  static const String authHeader = 'Authorization';
  static const String timestampHeader = 'X-Timestamp';
  static const String signatureHeader = 'X-Signature';
  static const String deviceHeader = 'X-Device-ID';
  static const String versionHeader = 'X-App-Version';
  static const String platformHeader = 'X-Platform';
  static const String fcmTokenHeader = 'X-FCM-Token';
}
