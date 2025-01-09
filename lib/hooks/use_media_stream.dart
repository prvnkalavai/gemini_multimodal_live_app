// lib/hooks/use_media_stream.dart
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class MediaStreamHook {
  MediaStream? _localStream;

  Future<MediaStream?> getMediaStream() async {
    if (_localStream != null) {
      return _localStream;
    }

    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': true,
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      return _localStream;
    } catch (e) {
      debugPrint('Error getting media stream: $e');
      return null;
    }
  }

  void dispose() {
    _localStream?.dispose();
    _localStream = null;
  }
}