import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/app_config.dart';
import '../../core/config/remote_config.dart';
import '../../core/network/api_client.dart';
import '../../core/network/websocket_client.dart';
import '../../core/security/secure_storage.dart';
import '../../features/user/services/user_api_service.dart';

/// App-level providers

// AppConfig provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.staging; // Points to your VPS: 49.43.1.100:5000
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

// User API Service provider
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserApiService(apiClient);
});

// User profile from backend
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final userService = ref.read(userApiServiceProvider);
    return await userService.getMyProfile();
  } catch (e) {
    return null;
  }
});

// Nearby users from backend
final nearbyUsersProvider = FutureProvider<List<dynamic>>((ref) async {
  try {
    final userService = ref.read(userApiServiceProvider);
    return await userService.getNearby(radius: 5, limit: 20);
  } catch (e) {
    return [];
  }
});

// Remote Config provider — fetches from backend, falls back to defaults
final remoteConfigProvider =
    AsyncNotifierProvider<RemoteConfigNotifier, RemoteConfig>(
  RemoteConfigNotifier.new,
);

class RemoteConfigNotifier extends AsyncNotifier<RemoteConfig> {
  @override
  Future<RemoteConfig> build() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get('/config');
      final data = response.data as Map<String, dynamic>;
      final configs = data['data'] as List<dynamic>? ?? [];

      // Build config map from backend
      final configMap = <String, dynamic>{};
      for (final item in configs) {
        configMap[item['key'] as String] = item['value'];
      }

      // Merge with defaults (backend values override defaults)
      return RemoteConfig.withValues(configMap);
    } catch (e) {
      // If backend unreachable, use cached or defaults
      return RemoteConfig.defaults();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
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
