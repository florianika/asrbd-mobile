import 'dart:async';
import 'dart:convert';

import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/field_work_status.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:connectivity_plus/connectivity_plus.dart';

class FieldWorkCubit extends Cubit<FieldWorkStatus> {
  final Uri wsUri;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  StreamSubscription? _connectivitySubscription;
  Timer? _reconnectTimer;

  int _retryCount = 0;
  static const int _maxRetries = 5; // Increased max retries
  bool _isConnecting = false;
  bool _shouldReconnect = true;

  final StorageService _storage = StorageService();

  FieldWorkCubit({required this.wsUri}) : super(FieldWorkStatus.initial()) {
    _initialize();
    _setupConnectivityListener();
  }

  Future<void> _initialize() async {
    try {
      final storedValue =
          await _storage.getString(key: StorageKeys.fieldWorkStatus);
      if (storedValue != null) {
        final status = FieldWorkStatus.fromJson(jsonDecode(storedValue));
        emit(status);
      }
    } catch (e) {
      // print('Error loading stored fieldWorkStatus: $e');
    }

    await _connectWebSocket();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && _channel == null) {
        // print('Network connectivity restored, attempting reconnection...');
        _retryCount = 0; // Reset retry counter when network is back
        _connectWebSocket();
      }
    });
  }

  Future<void> _connectWebSocket() async {
    if (_isConnecting || !_shouldReconnect) return;

    if (_retryCount >= _maxRetries) {
      // print('Max retry attempts reached. Will retry when network changes.');
      _updateStatusWithError('Max retry attempts reached');
      return;
    }

    _isConnecting = true;
    // print('Attempt ${_retryCount + 1} to connect to WebSocket...');

    // Clean up existing connection first
    await _closeConnection();

    try {
      final token = await _storage.getString(key: StorageKeys.accessToken);
      if (token == null) {
        // print('No token found in storage.');
        _updateStatusWithError('Unauthorized');
        _isConnecting = false;
        return;
      }

      // Check network connectivity before attempting connection
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // print('No network connectivity available');
        _updateStatusWithError('No network connection');
        _isConnecting = false;
        return;
      }

      _channel = IOWebSocketChannel.connect(
        wsUri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: (error) {
          // print('WebSocket error: $error');
          _updateStatusWithError(error.toString());
          _scheduleReconnect();
        },
        onDone: () {
          // print('WebSocket connection closed');
          _updateStatusWithError('Connection closed');
          _scheduleReconnect();
        },
        cancelOnError: true,
      );

      // Update status to show we're connected
      _updateStatusWithSuccess('Connected');
    } catch (e) {
      // print('Failed to connect to WebSocket: $e');
      _updateStatusWithError('Connection failed: $e');
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _handleMessage(dynamic data) async {
    try {
      final jsonData = jsonDecode(data);

      if (jsonData is Map && jsonData.containsKey('isFieldworkTime')) {
        // Cast to Map<String, dynamic> to fix type issue
        final typedJsonData = Map<String, dynamic>.from(jsonData);
        final status = FieldWorkStatus.fromJson(typedJsonData);
        emit(status);

        await _storage.saveString(
          key: StorageKeys.fieldWorkStatus,
          value: data,
        );

        _retryCount = 0; // Reset retry counter on successful message
      }
    } catch (e) {
      // print('Error parsing WebSocket message: $e');
      _updateStatusWithError('Message parsing error: $e');
    }
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;

    _retryCount++;

    if (_retryCount >= _maxRetries) {
      // print(
      //     'Reached max retries ($_maxRetries). Will wait for network change.');
      return;
    }

    // Cancel any existing timer
    _reconnectTimer?.cancel();

    // Exponential backoff: 2^retryCount seconds, max 30 seconds
    final delaySeconds = (2 << _retryCount).clamp(2, 30);

    // print('Scheduling reconnect in $delaySeconds seconds...');
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _connectWebSocket();
    });
  }

  void _updateStatusWithError(String message) {
    final temp = FieldWorkStatus(
      isFieldworkTime: state.isFieldworkTime,
      startTime: state.startTime,
      fieldworkId: state.fieldworkId,
      msg: message,
    );
    temp.inError = true;
    emit(temp);
  }

  void _updateStatusWithSuccess(String message) {
    final temp = FieldWorkStatus(
      isFieldworkTime: state.isFieldworkTime,
      startTime: state.startTime,
      fieldworkId: state.fieldworkId,
      msg: message,
    );
    temp.inError = false;
    emit(temp);
  }

  Future<void> _closeConnection() async {
    await _subscription?.cancel();
    _subscription = null;

    if (_channel != null) {
      try {
        await _channel!.sink.close(status.goingAway);
      } catch (e) {
        // print('Error closing WebSocket: $e');
      }
      _channel = null;
    }
  }

  // Public method to manually trigger reconnection
  Future<void> forceReconnect() async {
    // print('Force reconnect requested');
    _retryCount = 0;
    await _connectWebSocket();
  }

  // Public method to reconnect with fresh token (e.g., after authentication)
  Future<void> reconnectWithFreshToken() async {
    // print('Reconnecting with fresh token');
    _retryCount = 0;
    _shouldReconnect = true;
    await _closeConnection();
    await _connectWebSocket();
  }

  @override
  Future<void> close() async {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    await _connectivitySubscription?.cancel();
    await _closeConnection();
    return super.close();
  }
}
