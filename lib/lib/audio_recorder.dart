// lib/lib/audio_recorder.dart
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

class AudioRecorder {
  FlutterSoundRecorder? _recorder;
  bool _isInitialized = false;
  bool _isRecording = false;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  StreamSubscription? _recordingStreamSubscription;

  Stream<Map<String, dynamic>> get onEvent => _eventController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _recorder = FlutterSoundRecorder();

// Special handling for web platform
    if (kIsWeb) {
      await _recorder!.openRecorder();
    } else {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      await _recorder!.openRecorder();
    }

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
    _recordingStreamSubscription?.cancel();
  }

  Future<void> start() async {
    if (!_isInitialized) await initialize();
    if (_isRecording) return;

    print("Audio recorder starting...");

    try {
      // Configure recorder differently for web
      if (kIsWeb) {
        await _recorder!.startRecorder(
          codec: Codec.opusWebM,
          numChannels: 1,
          sampleRate: 44100,
          bitRate: 32000, // Standard web bitrate
        );
      } else {
        await _recorder!.startRecorder(
          codec: Codec.opusWebM,
          numChannels: 1,
          sampleRate: 16000,
        );
      }

      _isRecording = true;

      // Set shorter subscription duration for more frequent updates
      await _recorder!
          .setSubscriptionDuration(const Duration(milliseconds: 100));

      _recordingStreamSubscription = _recorder!.onProgress!.listen(
        (RecordingDisposition? result) {
          if (result != null && result.decibels != null) {
            double volume = _calculateVolumeFromDecibels(result.decibels!);
            print(
                "Recording volume: $volume, Raw Decibels: ${result.decibels}"); // Debug log

            _eventController.add({
              'event': 'volume',
              'data': volume.clamp(0.0, 1.0),
            });
          }
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

  double _calculateVolumeFromDecibels(double decibels) {
// Flutter Sound on web typically provides decibels in range 0 to 100
// Where 0 is silence and ~90-100 is very loud
    const double minDb = 0.0;
    const double maxDb = 100.0;

// Ensure decibels are within expected range
    double clampedDecibels = decibels.clamp(minDb, maxDb);

// Convert to 0-1 range
    double normalizedVolume = clampedDecibels / maxDb;

// Apply a curve to make the volume changes more natural
// Using square root to make middle-range sounds more prominent
    normalizedVolume = normalizedVolume.clamp(0.0, 1.0);
    normalizedVolume = sqrt(normalizedVolume);

    print(
        "Raw dB: $decibels, Clamped: $clampedDecibels, Normalized: $normalizedVolume");

    return normalizedVolume;
  }

  Future<void> stop() async {
    if (!_isRecording) return;

    try {
      await _recorder?.stopRecorder();
      await _recordingStreamSubscription
          ?.cancel(); // Cancel the stream subscription
      _recordingStreamSubscription = null;
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
    _recordingStreamSubscription?.cancel();
    _eventController.close();
    _isInitialized = false;
    _isRecording = false;
    print("Audio recorder disposed");
  }
}
