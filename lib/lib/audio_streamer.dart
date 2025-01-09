// lib/lib/audio_streamer.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart';

class AudioStreamer {
  final FlutterSoundPlayer context;
  final VoidCallback onComplete;
  bool _isInitialized = false;
  final int sampleRate;
  final int numChannels;
  bool _isStreaming = false;
  List<int> _audioBuffer = [];
  bool _isBuffering = false;


  AudioStreamer({
    required this.context,
    required this.onComplete,
    this.sampleRate = 24000,
    this.numChannels = 1,
  });

  Future<void> init() async {
    print("Initializing audio streamer...");
    if (!_isInitialized) {
      await context.openPlayer();
      _isInitialized = true;
      print("Audio streamer initialized");
    }
  }


  Future<void> play(List<int> audioData) async {
    _audioBuffer.addAll(audioData);

    if(!_isBuffering){
        _isBuffering = true;
    }

  }
  Future<void> process() async {
    if(_audioBuffer.isNotEmpty)
        await _processBuffer();
    _isBuffering = false;
  }
  Future<void> _processBuffer() async {
    try {
        if (!_isInitialized) await init();
         _isStreaming = true;
           await context.startPlayer(
             fromDataBuffer: Uint8List.fromList(_audioBuffer),
              sampleRate: sampleRate,
              numChannels: numChannels,
            codec: Codec.pcm16,
             whenFinished: () {
               print("Audio playback completed");
              _isStreaming = false;
               _audioBuffer = [];
              onComplete();
           }
      );
    print("Audio playback started");
   } catch (e) {
         print("Audio playback error: $e");
         _isStreaming = false;
         _audioBuffer = [];
           rethrow;
       }
  }

  Future<void> stop() async {
    if (!_isStreaming) return;
    try {
      await context.stopPlayer();
      _isStreaming = false;

    } catch (e) {
      print("Error stopping player: $e");
    }
  }

  Future<void> dispose() async {
      await stop();
    await context.closePlayer();
    _isInitialized = false;
  }

  Future<void> start() async {
    if (_isStreaming) return;
    _isStreaming = true;
  }

  Future<void> resume() async {
    if (context.isPaused) {
      await context.resumePlayer();
    }
    _isStreaming = false;
  }
}