// lib/lib/websocket_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String url;
  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketClient(this.url);

  Stream<Map<String, dynamic>> get onEvent => _eventController.stream;

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      (data) {
        final decoded = jsonDecode(data);
        _eventController.add({
          'event': 'message',
          'data': decoded,
        });
      },
      onDone: () {
        _eventController.add({
          'event': 'close',
          'data': null,
        });
      },
      onError: (error) {
        _eventController.add({
          'event': 'error',
          'data': error,
        });
      },
    );
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void close() {
    _channel?.sink.close();
    _eventController.close();
  }
}