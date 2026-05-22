import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../config/app_config.dart';

/// WebSocket Client
/// Real-time messaging with auto-reconnect
enum WebSocketState { disconnected, connecting, connected }

class WebSocketClient {
  final AppConfig config;
  WebSocketChannel? _channel;
  WebSocketState _state = WebSocketState.disconnected;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;

  final _stateController = StreamController<WebSocketState>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<WebSocketState> get stateStream => _stateController.stream;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  WebSocketState get state => _state;

  WebSocketClient({required this.config});

  void connect(String token) {
    if (_state == WebSocketState.connected) return;

    _updateState(WebSocketState.connecting);

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('${config.wsBaseUrl}?token=$token'),
      );

      _channel!.stream.listen(
        _onMessage,
        onDone: _onDone,
        onError: _onError,
      );

      _updateState(WebSocketState.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();
    } catch (e) {
      if (kDebugMode) debugPrint('WebSocket connect error: $e');
      _scheduleReconnect(token);
    }
  }

  void _onMessage(dynamic data) {
    try {
      final message = jsonDecode(data as String) as Map<String, dynamic>;

      // Handle pong response
      if (message['type'] == 'pong') return;

      _messageController.add(message);
    } catch (e) {
      if (kDebugMode) debugPrint('WebSocket parse error: $e');
    }
  }

  void _onDone() {
    _stopHeartbeat();
    _updateState(WebSocketState.disconnected);
    // Auto-reconnect handled by caller
  }

  void _onError(dynamic error) {
    if (kDebugMode) debugPrint('WebSocket error: $error');
    _stopHeartbeat();
    _updateState(WebSocketState.disconnected);
  }

  void send(Map<String, dynamic> message) {
    if (_state != WebSocketState.connected) {
      if (kDebugMode) debugPrint('WebSocket not connected, cannot send');
      return;
    }
    _channel?.sink.add(jsonEncode(message));
  }

  void sendTyping(String conversationId) {
    send({
      'type': 'typing',
      'conversationId': conversationId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  void sendStopTyping(String conversationId) {
    send({
      'type': 'stop_typing',
      'conversationId': conversationId,
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      send({'type': 'ping'});
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void _scheduleReconnect(String token) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) debugPrint('Max reconnect attempts reached');
      return;
    }

    final delay = Duration(seconds: (1 << _reconnectAttempts).clamp(1, 30));
    _reconnectAttempts++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () => connect(token));
  }

  void _updateState(WebSocketState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void disconnect() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _updateState(WebSocketState.disconnected);
  }

  void dispose() {
    disconnect();
    _stateController.close();
    _messageController.close();
  }
}
