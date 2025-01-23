// lib/contexts/live_api_context.dart
import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/core/api_client.dart';
import 'package:gemini_multimodal_live_app/core/models/live_config.dart';
import 'package:gemini_multimodal_live_app/core/models/live_message.dart';
import 'dart:convert';

class LiveAPIProvider extends StatefulWidget {
  final String apiKey;
  final String url;
  final Widget child;
  final Function(List<int>)? onAudioData;
  final bool onAudioStreamerReady;
  final Function()? onAudioComplete;

  const LiveAPIProvider({
    super.key,
    required this.apiKey,
    required this.url,
    required this.child,
    this.onAudioData,
    this.onAudioStreamerReady = false,
    this.onAudioComplete,
  });

  @override
  State<LiveAPIProvider> createState() => _LiveAPIProviderState();
}

class _LiveAPIProviderState extends State<LiveAPIProvider> {
  late ApiClient _apiClient;
  LiveConfig? _currentConfig;
  final ValueNotifier<List<String>> _logMessages = ValueNotifier([]);
  Function(ToolCall)? _onToolCall;
  Function(List<int>)? _onAudioData;
  bool _onAudioStreamerReady = false;
  Function()? _onAudioComplete;

  @override
  void initState() {
    super.initState();
    _onAudioData = widget.onAudioData;
    _onAudioComplete = widget.onAudioComplete;
    _onAudioStreamerReady = widget.onAudioStreamerReady;
    _apiClient = ApiClient(url: widget.url, apiKey: widget.apiKey);
    _apiClient.onData = _handleData;
    _apiClient.onDone = () {
      addToLog('WebSocket closed');
    };
    _apiClient.onError = (error) {
      addToLog('WebSocket error: $error');
    };
    _apiClient.connect();
  }

  void setConfig(LiveConfig config) {
    _currentConfig = config;
    _sendSetupMessage();
  }

  void _sendSetupMessage() {
    if (_currentConfig != null) {
      final message = SetupMessage(setup: _currentConfig!);
      _apiClient.send(message.toJson());
      addToLog('Sent setup message: ${message.toJson()}');
    }
  }

  void sendClientContent(ClientContent content) {
    final message = ClientContentMessage(clientContent: content);
    print("Sending client content: ${message.toJson()}");
    _apiClient.send(message.toJson());
    addToLog('Sent client content: ${message.toJson()}');
    print("Sent client content: ${message.toJson()}");
  }

  void sendRealtimeInput(RealtimeInput input) {
    print(
        "[LiveAPIContext] Received realtime input, media chunks: ${input.mediaChunks.length}"); // Log message
    final message = RealtimeInputMessage(realtimeInput: input);
    _apiClient.send(message.toJson());
    addToLog('Sent realtime input: ${message.toJson()}');
  }

  void sendToolResponse(ToolResponse response) {
    final message = ToolResponseMessage(toolResponse: response);
    _apiClient.send(message.toJson());
    addToLog('Sent tool response: ${message.toJson()}');
  }

  void _handleData(dynamic data) {
    try {
      print("[LiveAPIContext] Received raw data type: ${data.runtimeType}");
      String jsonString;
      if (data is List<int>) {
        jsonString = String.fromCharCodes(data);
      } else {
        jsonString = data.toString();
      }

      final jsonData = jsonDecode(jsonString);

      if (jsonData['serverContent'] != null) {
        final serverContent = jsonData['serverContent'];
        final modelTurn = serverContent['modelTurn'];

        if (modelTurn != null) {
          final parts = modelTurn['parts'] as List;
          for (var part in parts) {
            if (part['inlineData'] != null) {
              final inlineData = part['inlineData'];

              if (inlineData['mimeType'].toString().startsWith('audio/') &&
                  _onAudioData != null) {
                final decoded = base64Decode(inlineData['data']);
                if (_onAudioStreamerReady) {
                  _onAudioData!(decoded);
                  // No need to wait for turnComplete to start processing
                }
              }
            }
          }
        }

        // Handle turn completion
        if (serverContent['turnComplete'] == true) {
          _onAudioComplete?.call();
        }
      }
    } catch (e, stack) {
      print("Error handling WebSocket data: $e");
      print("Stack trace: $stack");
    }
  }

  void addToLog(String message) {
    _logMessages.value = [..._logMessages.value, message];
  }

  @override
  Widget build(BuildContext context) {
    return _LiveAPIContext(
      apiClient: _apiClient,
      logMessages: _logMessages,
      setConfig: setConfig,
      sendClientContent: sendClientContent,
      sendRealtimeInput: sendRealtimeInput,
      sendToolResponse: sendToolResponse,
      onToolCall: _onToolCall,
      onAudioData: _onAudioData,
      onAudioStreamerReady: _onAudioStreamerReady,
      onAudioComplete: _onAudioComplete,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _apiClient.close();
    _logMessages.dispose();
    super.dispose();
  }
}

class _LiveAPIContext extends InheritedWidget {
  final ApiClient apiClient;
  final ValueNotifier<List<String>> logMessages;
  final Function(LiveConfig) setConfig;
  final Function(ClientContent) sendClientContent;
  final Function(RealtimeInput) sendRealtimeInput;
  final Function(ToolResponse) sendToolResponse;
  Function(ToolCall)? onToolCall;
  Function(List<int>)? onAudioData;
  Function()? onAudioComplete;
  bool onAudioStreamerReady;

  _LiveAPIContext({
    required this.apiClient,
    required this.logMessages,
    required this.setConfig,
    required this.sendClientContent,
    required this.sendRealtimeInput,
    required this.sendToolResponse,
    this.onToolCall,
    this.onAudioData,
    this.onAudioComplete,
    required this.onAudioStreamerReady,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _LiveAPIContext oldWidget) {
    return apiClient != oldWidget.apiClient ||
        logMessages != oldWidget.logMessages;
  }
}

class LiveAPIContext {
  static _LiveAPIContext of(BuildContext context) {
    final _LiveAPIContext? result =
        context.dependOnInheritedWidgetOfExactType<_LiveAPIContext>();
    assert(result != null, 'No LiveAPIContext found in context');
    return result!;
  }

  static ApiClient apiClient(BuildContext context) => of(context).apiClient;
  static ValueNotifier<List<String>> logMessages(BuildContext context) =>
      of(context).logMessages;
  static void setConfig(BuildContext context, LiveConfig config) =>
      of(context).setConfig(config);
  static void sendClientContent(BuildContext context, ClientContent content) =>
      of(context).sendClientContent(content);
  static void sendRealtimeInput(BuildContext context, RealtimeInput input) =>
      of(context).sendRealtimeInput(input);
  static void sendToolResponse(BuildContext context, ToolResponse response) =>
      of(context).sendToolResponse(response);
  static setOnToolCall(BuildContext context, Function(ToolCall)? callback) {
    of(context).onToolCall = callback;
  }

  static setOnAudioData(BuildContext context, Function(List<int>)? callback) {
    of(context).onAudioData = callback;
  }

  static setOnAudioComplete(BuildContext context, Function()? callback) {
    of(context).onAudioComplete = callback;
  }

  static bool getOnAudioStreamerReady(BuildContext context) =>
      of(context).onAudioStreamerReady;
  static setOnAudioStreamerReady(BuildContext context, bool val) {
    of(context).onAudioStreamerReady = val;
  }
}
