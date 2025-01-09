import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/lib/audio_recorder.dart';
import 'package:gemini_multimodal_live_app/lib/video_capture.dart';
import 'package:gemini_multimodal_live_app/lib/screen_capture.dart'; 
import 'package:camera/camera.dart';
import 'audio_pulse.dart';

class ControlTray extends StatefulWidget {
  final bool supportsVideo;
  final Function(VideoCapture?)? onVideoStreamChange;
  final Function(ScreenCapture?)? onScreenStreamChange;

  const ControlTray({
    super.key,
    this.supportsVideo = true,
    this.onScreenStreamChange,
    this.onVideoStreamChange,
  });

  @override
  State<ControlTray> createState() => _ControlTrayState();
}

class _ControlTrayState extends State<ControlTray> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  VideoCapture? _videoCapture;
  ScreenCapture? _screenCapture;
  bool _isMuted = false;
  double _volume = 0;
  Widget? _cameraPreview;
  Widget? _screenPreview;

  @override
  void initState() {
    super.initState();
    _audioRecorder.on('volume', (volume) {
      setState(() => _volume = volume);
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      if (_isMuted) {
        _audioRecorder.stop();
      } else {
        _audioRecorder.start();
      }
    });
  }

  void _toggleScreen() {
    if (_screenCapture == null) {
      _screenCapture = ScreenCapture(onFrame: (frame) {
        // Handle frame data
      });
      _screenCapture!.startCapture();
      _buildScreenPreview();
    } else {
      _screenCapture!.stopCapture();
      _screenCapture!.dispose();
      _screenCapture = null;
      setState(() {
        _screenPreview = null;
      });
    }
    widget.onScreenStreamChange?.call(_screenCapture);
  }

  void _toggleVideo() {
    if (_videoCapture == null) {
      _videoCapture = VideoCapture(onFrame: (frame) {
        // Handle frame data
      });
      _videoCapture!.startCapture();
      _buildCameraPreview();
    } else {
      _videoCapture!.stopCapture();
      _videoCapture!.dispose();
      _videoCapture = null;
      setState(() {
        _cameraPreview = null;
      });
    }
    widget.onVideoStreamChange?.call(_videoCapture);
  }

  Future<void> _buildCameraPreview() async {
    if (_videoCapture?.controller != null && _videoCapture!.isInitialized) {
      setState(() {
        _cameraPreview = AspectRatio(
          aspectRatio: _videoCapture!.controller!.value.aspectRatio,
          child: CameraPreview(_videoCapture!.controller!),
        );
      });
    }
  }

  Future<void> _buildScreenPreview() async {
    if (_screenCapture?.controller != null && _screenCapture!.isInitialized) {
      setState(() {
        _screenPreview = AspectRatio(
          aspectRatio: _screenCapture!.controller!.value.aspectRatio,
          child: CameraPreview(_screenCapture!.controller!),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                onPressed: _toggleMute,
              ),
              const SizedBox(width: 16),
              AudioPulse(
                volume: _volume,
                active: !_isMuted,
              ),
              if (widget.supportsVideo) ...[
                const SizedBox(width: 16),
                 IconButton(
                  icon: Icon(_screenCapture != null ? Icons.screen_share : Icons.stop_screen_share),
                  onPressed: _toggleScreen,
                ),
                IconButton(
                  icon: Icon(
                      _videoCapture != null ? Icons.videocam : Icons.videocam_off),
                  onPressed: _toggleVideo,
                ),
              ],
            ],
          ),
          if (_cameraPreview != null) _cameraPreview!,
          if (_screenPreview != null) _screenPreview!
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _videoCapture?.dispose();
        _screenCapture?.dispose();

    super.dispose();
  }
}