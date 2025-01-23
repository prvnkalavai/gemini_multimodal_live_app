import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

/// Captures audio in real time on mobile, emitting two types of events:
///   1) 'volume': decibel-based volume readings for a UI meter
///   2) 'data': small chunks of raw audio bytes for streaming to Gemini
///
/// Ignored on web (throwing an error instead).
class AudioRecorder {
  FlutterSoundRecorder? _recorder;

  // StreamController used to gather raw audio chunks
  final _audioDataController = StreamController<Uint8List>.broadcast();
  StreamSubscription<Uint8List>? _audioDataSubscription;

  // This event controller broadcasts events to outside listeners
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  bool _isInitialized = false;
  bool _isRecording = false;

  /// Expose a stream of { event: 'volume'|'data'|'error', data: <dynamic> } objects
  Stream<Map<String, dynamic>> get onEvent => _eventController.stream;

  /// Subscribe to a named event easily
  void on(String eventName, Function(dynamic) callback) {
    _eventController.stream.listen((event) {
      if (event['event'] == eventName) {
        callback(event['data']);
      }
    });
  }

  /// Initialize the recorder for mobile only; if web, throws an error
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      throw UnsupportedError('AudioRecorder does not support web in this snippet.');
    }

    // Request microphone permission
    final micStatus = await Permission.microphone.request();
    if (micStatus != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }

    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    _isInitialized = true;
    print('[AudioRecorder] Initialized successfully.');
  }

  /// Start the recorder in streaming mode, piping raw chunks to _audioDataController
  Future<void> start() async {
    if (!_isInitialized) await initialize();
    if (_isRecording) return;

    print('[AudioRecorder] Starting capture...');
    _isRecording = true;

    // IMPORTANT: For real-time chunk audio, specify toStream: _audioDataController.sink
    // so flutter_sound sends raw audio in small bursts (e.g. ~10-20ms blocks).
    await _recorder!.startRecorder(
      toStream: _audioDataController.sink,  // <--- critical for chunk streaming
      codec: Codec.pcm16WAV,                // or Codec.opusWebM, etc.
      numChannels: 1,
      sampleRate: 44100,                    // Standard audio sample rate
      bitRate: 16 * 44100,                  // 16-bit audio
    );

    // Listen for raw chunks from _audioDataController.
    _audioDataSubscription = _audioDataController.stream.listen(
      (Uint8List chunk) {
        // Each chunk is raw PCM or compressed data, depending on codec
        print('[AudioRecorder] Got an audio chunk of size ${chunk.lengthInBytes}, codec: pcm16WAV');
        // Emit a "data" event to external code (control_tray).
        _eventController.add({'event': 'data', 'data': chunk});
      },
      onError: (error) {
        print('[AudioRecorder] Data stream error: $error');
        _eventController.add({'event': 'error', 'data': error.toString()});
      },
    );

    // Optionally, also monitor decibels for a volume meter
    // setSubscriptionDuration controls how often onProgress fires
      await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 50)); // Set shorter subscription duration for more responsive volume updates
    _recorder!.onProgress?.listen((disposition) {
      if (disposition.decibels != null) {
        // Log raw decibel values to understand the range
        print('[AudioRecorder] Raw decibels: ${disposition.decibels}'); 
        double vol = _calculateVolumeFromDecibels(disposition.decibels!);
        _eventController.add({'event': 'volume', 'data': vol});
      }
    });


    print('[AudioRecorder] Started recording successfully.');
  }

  /// Stop the recording stream
  Future<void> stop() async {
    if (!_isRecording) return;

    print('[AudioRecorder] Stopping capture...');
    try {
      await _recorder?.stopRecorder();
      await _audioDataSubscription?.cancel();
      _audioDataSubscription = null;
      _isRecording = false;
      print('[AudioRecorder] Stopped successfully.');
    } catch (e, st) {
      print('[AudioRecorder] Error stopping recorder: $e\n$st');
    }
  }

  /// Clean up resources
  void dispose() {
    stop();
    _recorder?.closeRecorder();
    _audioDataSubscription?.cancel();
    _audioDataController.close();
    _eventController.close();
    _isInitialized = false;
    _isRecording = false;
    print('[AudioRecorder] Disposed.');
  }

  /// True if currently capturing
  bool get isRecording => _isRecording;

  /// Convert decibels (0..something) to a 0..1 volume meter
  double _calculateVolumeFromDecibels(double decibels) {
    // Web audio API typically provides decibels in range -160 to 0
    // where -160 is silence and 0 is maximum volume
    const double minDb = 0.0;  // Silence threshold
    const double maxDb = 100.0;     // Maximum volume
    
    // Ensure decibels are within expected range
    double clampedDb = decibels.clamp(minDb, maxDb);
    
    // Convert from logarithmic to linear scale and normalize to 0-1
    // Adding maxDb to shift the range from [-160,0] to [0,160]
    double normalizedVolume = (clampedDb + minDb) / (maxDb - minDb);
    
    // Apply non-linear curve to make quiet sounds more visible
    normalizedVolume = sqrt(normalizedVolume);
    
    // Ensure volume is between 0 and 1
    normalizedVolume = normalizedVolume.clamp(0.0, 1.0);
    
    print('[AudioRecorder] Raw dB: $decibels, Normalized: $normalizedVolume'); 
    
    return normalizedVolume;
  }
}