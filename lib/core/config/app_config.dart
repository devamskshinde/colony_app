import 'environment.dart';

/// Colony App Configuration
/// Runtime configuration based on environment
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String wsBaseUrl;
  final String cdnBaseUrl;
  final String socketUrl;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashReporting;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.cdnBaseUrl,
    required this.socketUrl,
    this.enableLogging = false,
    this.enableAnalytics = true,
    this.enableCrashReporting = true,
  });

  static AppConfig get dev => const AppConfig(
        environment: Environment.development,
        apiBaseUrl: 'https://dev-api.colonyapp.in/v1',
        wsBaseUrl: 'wss://dev-ws.colonyapp.in',
        cdnBaseUrl: 'https://dev-cdn.colonyapp.in',
        socketUrl: 'https://dev-socket.colonyapp.in',
        enableLogging: true,
        enableAnalytics: false,
        enableCrashReporting: false,
      );

  static AppConfig get staging => const AppConfig(
        environment: Environment.staging,
        apiBaseUrl: 'https://staging-api.colonyapp.in/v1',
        wsBaseUrl: 'wss://staging-ws.colonyapp.in',
        cdnBaseUrl: 'https://staging-cdn.colonyapp.in',
        socketUrl: 'https://staging-socket.colonyapp.in',
        enableLogging: true,
        enableAnalytics: true,
        enableCrashReporting: true,
      );

  static AppConfig get production => const AppConfig(
        environment: Environment.production,
        apiBaseUrl: 'https://api.colonyapp.in/v1',
        wsBaseUrl: 'wss://ws.colonyapp.in',
        cdnBaseUrl: 'https://cdn.colonyapp.in',
        socketUrl: 'https://socket.colonyapp.in',
        enableLogging: false,
        enableAnalytics: true,
        enableCrashReporting: true,
      );

  bool get isProduction => environment == Environment.production;
  bool get isDevelopment => environment == Environment.development;
}
