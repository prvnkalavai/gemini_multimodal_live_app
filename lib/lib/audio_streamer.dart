import 'dart:async';
import 'dart:typed_data';
import 'dart:collection';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart';

class AudioStreamer {
  final FlutterSoundPlayer context;
  final VoidCallback onComplete;
  bool _isInitialized = false;
  final int sampleRate;
  final int numChannels;
  bool _isPlaying = false;
  bool _isPaused = false;
  final Queue<List<int>> _audioQueue = Queue();
  bool _isProcessingQueue = false;
  List<int> _currentBuffer = [];

  // Buffer settings
  static const int _minBufferSize =
      2; // Minimum chunks before starting playback
  static const int _maxBufferSize = 4; // Maximum chunks to buffer
  bool _isFirstChunk = true;

  AudioStreamer({
    required this.context,
    required this.onComplete,
    this.sampleRate = 24000,
    this.numChannels = 1,
  });

  Future<void> init() async {
    if (!_isInitialized) {
      try {
        await context.openPlayer();
        _isInitialized = true;
        print("Audio streamer initialized successfully");
      } catch (e) {
        print("Error initializing audio streamer: $e");
        rethrow;
      }
    }
  }

  Future<void> play(List<int> audioData) async {
    if (!_isInitialized) await init();

    _audioQueue.add(audioData);
    print(
        "Added ${audioData.length} bytes to queue. Queue size: ${_audioQueue.length}");

    if (_isFirstChunk || _audioQueue.length >= _minBufferSize) {
      _isFirstChunk = false;
      if (!_isProcessingQueue) {
        _processQueue();
      }
    }
  }

  Future<void> _processQueue() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    try {
      while (_audioQueue.isNotEmpty || _currentBuffer.isNotEmpty) {
        if (_isPaused) {
          await Future.delayed(Duration(milliseconds: 100));
          continue;
        }

        // Fill buffer if needed
        while (_currentBuffer.isEmpty && _audioQueue.isNotEmpty) {
          _currentBuffer.addAll(_audioQueue.removeFirst());
        }

        if (_currentBuffer.isNotEmpty) {
          _isPlaying = true;
          print("Playing buffer of size: ${_currentBuffer.length}");

          await context.startPlayer(
              fromDataBuffer: Uint8List.fromList(_currentBuffer),
              codec: Codec.pcm16,
              numChannels: numChannels,
              sampleRate: sampleRate,
              whenFinished: () {
                _isPlaying = false;
                print("Finished playing current buffer");
              });

          // Wait for current playback to complete
          while (_isPlaying) {
            await Future.delayed(Duration(milliseconds: 50));
          }

          _currentBuffer.clear();
        }

        // Buffer next chunks
        while (_audioQueue.isNotEmpty &&
            _currentBuffer.length < _maxBufferSize * 11520) {
          _currentBuffer.addAll(_audioQueue.removeFirst());
        }
      }
    } catch (e) {
      print("Error processing audio: $e");
    } finally {
      _isProcessingQueue = false;
      if (_audioQueue.isEmpty && _currentBuffer.isEmpty) {
        onComplete();
      }
    }
  }

  Future<void> process() async {
    if (_audioQueue.isEmpty && _currentBuffer.isEmpty) return;

    if (!_isProcessingQueue) {
      _processQueue();
    }
  }

  Future<void> stop() async {
    if (_isPlaying) {
      try {
        await context.stopPlayer();
        _isPlaying = false;
        _audioQueue.clear();
        _currentBuffer.clear();
        _isProcessingQueue = false;
      } catch (e) {
        print("Error stopping player: $e");
      }
    }
  }

  Future<void> pause() async {
    if (_isPlaying && !_isPaused) {
      try {
        await context.pausePlayer();
        _isPaused = true;
      } catch (e) {
        print("Error pausing player: $e");
      }
    }
  }

  Future<void> resume() async {
    if (_isPaused) {
      try {
        await context.resumePlayer();
        _isPaused = false;
      } catch (e) {
        print("Error resuming player: $e");
      }
    }
  }

  Future<void> dispose() async {
    await stop();
    await context.closePlayer();
    _isInitialized = false;
    _audioQueue.clear();
    _currentBuffer.clear();
  }

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  bool get isInitialized => _isInitialized;
}
