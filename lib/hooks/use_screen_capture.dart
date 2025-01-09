// lib/hooks/use_screen_capture.dart
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class ScreenCaptureHook {
  MediaStream? _screenStream;

  Future<MediaStream?> getScreenCaptureStream() async {
    if (_screenStream != null) {
      return _screenStream;
    }

    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'mandatory': {'chromeMediaSource': 'desktop'},
      }
    };

    try {
      _screenStream = await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      return _screenStream;
    } catch (e) {
      debugPrint('Error getting screen capture stream: $e');
      return null;
    }
  }

  void dispose() {
    _screenStream?.dispose();
    _screenStream = null;
  }
}