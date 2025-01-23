// lib/core/api_client.dart
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ApiClient {
  final String url;
  final String apiKey;
  WebSocketChannel? _channel;
  Function(dynamic)? onData;
  Function()? onDone;
  Function(dynamic)? onError;

  ApiClient({required this.url, required this.apiKey});

  void connect() {
    final fullUrl = '$url?key=$apiKey';
    _channel = WebSocketChannel.connect(Uri.parse(fullUrl));
    print('Connected to $fullUrl');

    _channel!.stream.listen(
      (data) {
        print('[ApiClient] Received data: $data'); // Log incoming message
        onData?.call(data);
      },
      onDone: onDone,
      onError: onError,
    );
  }

  void send(Map<String, dynamic> message) {
    if (_channel != null ) {
      print('[ApiClient] Sending message: ${jsonEncode(message)}'); // Log outgoing message
      _channel!.sink.add(jsonEncode(message));
    }
  }

  void close() {
    _channel?.sink.close();
  }
}