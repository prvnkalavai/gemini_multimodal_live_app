// lib/lib/audio_recorder.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder {
  FlutterSoundRecorder? _recorder;
  bool _isInitialized = false;
  bool _isRecording = false;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _recorderSubscription;
  StreamController<Uint8List>? _audioStreamController;

  Stream<Map<String, dynamic>> get onEvent => _eventController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _recorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    await _recorder!.openRecorder();
    _isInitialized = true;
    print("Audio recorder initialized");
  }

  void on(String event, Function callback) {
    _eventController.stream.listen((data) {
      if (data['event'] == event) {
        callback(data['data']);
      }
    });
  }

  void off(String event) {
    _recorderSubscription?.cancel();
  }

  Future<void> start() async {
    if (!_isInitialized) await initialize();
    if (_isRecording) return;

    print("Audio recorder starting...");

    try {
      _audioStreamController = StreamController<Uint8List>();

      await _recorder!.startRecorder(
        codec: Codec.opusWebM,
        toStream: _audioStreamController!.sink,
        numChannels: 1,
        sampleRate: 16000,
      );
      _isRecording = true;

      _recorderSubscription = _audioStreamController!.stream.listen(
        (Uint8List data) {
          _handleRecordingProgress(data);
        },
        onError: (error) {
          print("Recording error: $error");
          _eventController.add({
            'event': 'error',
            'data': error.toString(),
          });
        },
      );      

      print("Audio recorder started successfully");
    } catch (e) {
      print("Error starting recorder: $e");
      _isRecording = false;
      rethrow;
    }
  }

  void _handleRecordingProgress(Uint8List data) {
    _eventController.add({
      'event': 'data',
      'data': data,
    });
    // Calculate volume
    double volume = _calculateVolume(data);
    _eventController.add({
      'event': 'volume',
      'data': volume,
    });
    print('Audio data recorded and emitted ${data.length}');
  }

  double _calculateVolume(Uint8List data) {
    // Implement volume calculation from PCM data
    // This is a simplified example
    double sum = 0;
    for (int i = 0; i < data.length; i += 2) {
      int sample = data[i] | (data[i + 1] << 8);
      sum += sample * sample;
    }
    double vol = sum / (data.length / 2);
    print('Calculated volume $vol');
    return vol;
  }

  Future<void> stop() async {
    if (!_isRecording) return;

    try {
      await _recorder?.stopRecorder();
      await _audioStreamController?.close();
      await _recorderSubscription?.cancel();
      _audioStreamController = null;
      _isRecording = false;
      print("Audio recorder stopped");
    } catch (e) {
      print("Error stopping recorder: $e");
      rethrow;
    }
  }

  bool get isRecording => _isRecording;

  void dispose() {
    stop();
    _recorder?.closeRecorder();
    _recorderSubscription?.cancel();
    _audioStreamController?.close();
    _audioStreamController = null;
    _eventController.close();
    _isInitialized = false;
    _isRecording = false;
    print("Audio recorder disposed");
  }
}
