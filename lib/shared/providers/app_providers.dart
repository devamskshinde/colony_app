import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../core/config/remote_config.dart';
import '../../core/network/api_client.dart';
import '../../core/network/websocket_client.dart';
import '../../core/security/secure_storage.dart';

/// App-level providers

// AppConfig provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.production; // Switch to .dev/.staging as needed
});

// Secure Storage provider
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(config: config);
});

// WebSocket Client provider
final webSocketClientProvider = Provider<WebSocketClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return WebSocketClient(config: config);
});

// Remote Config provider
final remoteConfigProvider = StateProvider<RemoteConfig>((ref) {
  return RemoteConfig.defaults();
});

// Auth state provider
final isLoggedInProvider = StateProvider<bool>((ref) => false);

// Current user ID provider
final currentUserIdProvider = StateProvider<String?>((ref) => null);
