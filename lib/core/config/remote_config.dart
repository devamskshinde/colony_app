import 'package:flutter/foundation.dart';

/// Remote Config Model
/// Controls feature flags and dynamic configuration
@immutable
class RemoteConfig {
  final Map<String, dynamic> _values;
  final DateTime lastFetched;

  const RemoteConfig({
    required Map<String, dynamic> values,
    required this.lastFetched,
  }) : _values = values;

  factory RemoteConfig.defaults() => RemoteConfig(
        values: Map.from(_defaultValues),
        lastFetched: DateTime.fromMillisecondsSinceEpoch(0),
      );

  /// Create config with backend values merged over defaults
  factory RemoteConfig.withValues(Map<String, dynamic> backendValues) {
    final merged = Map<String, dynamic>.from(_defaultValues);
    merged.addAll(backendValues);
    return RemoteConfig(
      values: merged,
      lastFetched: DateTime.now(),
    );
  }

  static final Map<String, dynamic> _defaultValues = {
    // Feature flags
    'feature_radar': true,
    'feature_stories': true,
    'feature_chat': true,
    'feature_groups': true,
    'feature_discovery': true,
    'feature_dating': true,
    'feature_coins': true,
    'feature_live_location': false,
    'feature_video_call': false,
    'feature_marketplace': false,

    // Tier-specific features
    'feature_radar_free': true,
    'feature_radar_premium': true,
    'feature_stories_free': true,
    'feature_stories_premium': true,
    'feature_dating_free': true,
    'feature_dating_premium': true,
    'feature_boost_free': false,
    'feature_boost_premium': true,
    'feature_super_like_free': false,
    'feature_super_like_premium': true,

    // Limits
    'max_swipes_free': 20,
    'max_swipes_premium': -1, // -1 = unlimited
    'max_super_likes_free': 1,
    'max_super_likes_premium': 5,
    'radar_radius_free': 5.0,
    'radar_radius_premium': 25.0,
    'story_upload_max_mb': 10,

    // UI
    'show_ad_banner': true,
    'maintenance_mode': false,
    'force_update_version': '0.0.0',

    // Content
    'max_feed_age_hours': 48,
    'trending_threshold': 10,
    'nsfw_filter_enabled': true,
  };

  T getValue<T>(String key, {T? fallback}) {
    if (_values.containsKey(key)) {
      final value = _values[key];
      if (value is T) return value;
    }
    if (fallback != null) return fallback;
    throw Exception('RemoteConfig key "$key" not found');
  }

  bool isFeatureEnabled(String feature, [String userTier = 'free']) {
    // Check maintenance mode first
    if (getValue<bool>('maintenance_mode', fallback: false)) return false;

    // Check tier-specific flag first
    final tierKey = '${feature}_$userTier';
    if (_values.containsKey(tierKey)) {
      return getValue<bool>(tierKey, fallback: false);
    }

    // Fall back to general feature flag
    return getValue<bool>(feature, fallback: false);
  }

  bool get isMaintenanceMode =>
      getValue<bool>('maintenance_mode', fallback: false);

  String get forceUpdateVersion =>
      getValue<String>('force_update_version', fallback: '0.0.0');

  RemoteConfig copyWith({
    Map<String, dynamic>? values,
    DateTime? lastFetched,
  }) {
    return RemoteConfig(
      values: values ?? _values,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }
}
