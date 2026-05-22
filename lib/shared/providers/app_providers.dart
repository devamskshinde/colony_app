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

// Remote Config provider (Notifier-based for Riverpod 3.x)
final remoteConfigProvider =
    NotifierProvider<RemoteConfigNotifier, RemoteConfig>(
  RemoteConfigNotifier.new,
);

class RemoteConfigNotifier extends Notifier<RemoteConfig> {
  @override
  RemoteConfig build() => RemoteConfig.defaults();

  void updateConfig(RemoteConfig config) => state = config;
}

// Auth state provider
final isLoggedInProvider =
    NotifierProvider<IsLoggedInNotifier, bool>(IsLoggedInNotifier.new);

class IsLoggedInNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoggedIn(bool value) => state = value;
}

// Current user ID provider
final currentUserIdProvider =
    NotifierProvider<CurrentUserIdNotifier, String?>(
  CurrentUserIdNotifier.new,
);

class CurrentUserIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setUserId(String? id) => state = id;
}
