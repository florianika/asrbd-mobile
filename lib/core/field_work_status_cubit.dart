import 'dart:async';
import 'dart:convert';

import 'package:asrdb/core/local_storage/storage_keys.dart';
import 'package:asrdb/core/models/field_work_status.dart';
import 'package:asrdb/core/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class FieldWorkCubit extends Cubit<FieldWorkStatus> {
  final Uri wsUri;
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  int _retryCount = 0;
  static const int _maxRetries = 3;

  final StorageService _storage = StorageService();

  FieldWorkCubit({required this.wsUri}) : super(FieldWorkStatus.initial()) {
    _initialize();
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
      print('Error loading stored fieldWorkStatus: $e');
    }

    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    if (_retryCount >= _maxRetries) {
      print('Max retry attempts reached. Giving up.');
      return;
    }

    print('Attempt ${_retryCount + 1} to connect to WebSocket...');

    try {
      final token = await _storage.getString(key: StorageKeys.accessToken);
      if (token == null) {
        print('No token found in storage.');
        return;
      }

      _channel = IOWebSocketChannel.connect(
        wsUri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var temp = FieldWorkStatus(
          isFieldworkTime: false,
          startTime: null,
          fieldworkId: null,
          msg: "connected");
      emit(temp);

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: (error) {
          print('WebSocket error: $error');
          _retryConnection();
        },
        onDone: () {
          print('WebSocket closed');
          _retryConnection();
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _retryConnection();
    }
  }

  Future<void> _handleMessage(dynamic data) async {
    try {
      final jsonData = jsonDecode(data);

      // var temp = FieldWorkStatus(
      //     isFieldworkTime: false,
      //     startTime: null,
      //     fieldworkId: data.toString());
      // emit(temp);
      if (jsonData is Map && jsonData.containsKey('isFieldworkTime')) {
        final status = FieldWorkStatus.fromJson(jsonDecode(data));
        emit(status);
        await _storage.saveString(
          key: StorageKeys.fieldWorkStatus,
          value: jsonEncode(jsonData),
        );
        _retryCount = 0; // ✅ reset retry counter on successful message
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
      var temp = FieldWorkStatus(
          isFieldworkTime: false,
          startTime: null,
          fieldworkId: null,
          msg: e.toString());
      emit(temp);
    }
  }

  void _retryConnection() {
    _retryCount++;
    if (_retryCount >= _maxRetries) {
      print('Reached max retries ($_maxRetries). Stopping attempts.');
      return;
    }

    Future.delayed(const Duration(seconds: 3), () {
      _connectWebSocket();
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _channel?.sink.close(status.goingAway);
    return super.close();
  }
}
