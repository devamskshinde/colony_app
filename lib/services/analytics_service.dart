import 'package:flutter/foundation.dart';

/// Analytics Service
/// Track screens, events, and user properties
class AnalyticsService {
  static AnalyticsService? _instance;
  final List<_AnalyticsEvent> _eventBuffer = [];

  AnalyticsService._();

  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  /// Track screen view
  static void trackScreen(String screenName, {Map<String, dynamic>? properties}) {
    instance._track('screen_view', {
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
      ...?properties,
    });
  }

  /// Track custom event
  static void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    instance._track(eventName, {
      'timestamp': DateTime.now().toIso8601String(),
      ...?properties,
    });
  }

  /// Track user action
  static void trackAction(String action, {String? target, Map<String, dynamic>? properties}) {
    instance._track('user_action', {
      'action': action,
      'target': target,
      'timestamp': DateTime.now().toIso8601String(),
      ...?properties,
    });
  }

  /// Track error
  static void trackError(String error, {String? stackTrace, Map<String, dynamic>? properties}) {
    instance._track('error', {
      'error': error,
      'stack_trace': stackTrace,
      'timestamp': DateTime.now().toIso8601String(),
      ...?properties,
    });
  }

  /// Set user properties
  static void setUserProperties({
    String? userId,
    String? tier,
    String? location,
  }) {
    final props = <String, dynamic>{};
    if (userId != null) props['user_id'] = userId;
    if (tier != null) props['user_tier'] = tier;
    if (location != null) props['location'] = location;

    instance._track('set_user_properties', props);
  }

  void _track(String eventName, Map<String, dynamic> properties) {
    final event = _AnalyticsEvent(
      name: eventName,
      properties: properties,
      timestamp: DateTime.now(),
    );

    _eventBuffer.add(event);

    if (kDebugMode) {
      debugPrint('[Analytics] $eventName: ${properties.toString()}');
    }

    // In production: batch and send to server
    if (_eventBuffer.length >= 20) {
      _flush();
    }
  }

  void _flush() {
    // In production: POST _eventBuffer to analytics endpoint
    _eventBuffer.clear();
  }

  /// Flush remaining events
  static void dispose() {
    instance._flush();
  }
}

class _AnalyticsEvent {
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  _AnalyticsEvent({
    required this.name,
    required this.properties,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'properties': properties,
        'timestamp': timestamp.toIso8601String(),
      };
}
