// lib/hooks/use_webcam.dart
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebcamHook {
  MediaStream? _webcamStream;

  Future<MediaStream?> getWebcamStream() async {
    if (_webcamStream != null) {
      return _webcamStream;
    }

    final mediaConstraints = <String, dynamic>{
      'audio': false,
      'video': true,
    };

    try {
      _webcamStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      return _webcamStream;
    } catch (e) {
      debugPrint('Error getting webcam stream: $e');
      return null;
    }
  }

  void dispose() {
    _webcamStream?.dispose();
    _webcamStream = null;
  }
}