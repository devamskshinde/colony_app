import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/remote_config.dart';
import '../core/network/api_client.dart';
import '../shared/providers/app_providers.dart';

/// Remote Config Service
/// Fetches and caches feature flags from server
class RemoteConfigService {
  final ApiClient _apiClient;
  RemoteConfig _config = RemoteConfig.defaults();

  RemoteConfigService(this._apiClient);

  RemoteConfig get config => _config;

  /// Fetch latest config from server
  Future<RemoteConfig> fetchConfig() async {
    try {
      final response = await _apiClient.get('/config/flags');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        _config = RemoteConfig(
          values: data,
          lastFetched: DateTime.now(),
        );
        if (kDebugMode) debugPrint('Remote config updated');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Remote config fetch failed: $e');
      // Keep defaults
    }

    return _config;
  }

  /// Check if a feature is enabled for user tier
  bool isFeatureEnabled(String feature, String userTier) {
    return _config.isFeatureEnabled(feature, userTier);
  }

  /// Get a config value
  T getValue<T>(String key, {T? fallback}) {
    return _config.getValue<T>(key, fallback: fallback);
  }
}

/// Riverpod provider for remote config service
final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RemoteConfigService(apiClient);
});
