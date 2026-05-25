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

  // ─── Development: point to your local backend ────────────
  // Change this IP to your machine's IP when testing on a real device
  // Run `hostname -I` in WSL to find it, or use your public IP
  static AppConfig get dev => const AppConfig(
        environment: Environment.development,
        apiBaseUrl: 'http://10.0.2.2:5000/v1', // Android emulator localhost
        wsBaseUrl: 'ws://10.0.2.2:5000',
        cdnBaseUrl: 'http://10.0.2.2:5000',
        socketUrl: 'http://10.0.2.2:5000',
        enableLogging: true,
        enableAnalytics: false,
        enableCrashReporting: false,
      );

  // ─── Staging: your VPS IP ────────────────────────────────
  static AppConfig get staging => const AppConfig(
        environment: Environment.staging,
        apiBaseUrl: 'https://economies-spine-replaced-exchanges.trycloudflare.com/v1',
        wsBaseUrl: 'wss://economies-spine-replaced-exchanges.trycloudflare.com',
        cdnBaseUrl: 'https://economies-spine-replaced-exchanges.trycloudflare.com',
        socketUrl: 'https://economies-spine-replaced-exchanges.trycloudflare.com',
        enableLogging: true,
        enableAnalytics: true,
        enableCrashReporting: false,
      );

  // ─── Production: real domain ─────────────────────────────
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
