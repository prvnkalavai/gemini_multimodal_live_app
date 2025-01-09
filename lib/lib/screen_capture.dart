// lib/lib/screen_capture.dart
import 'dart:async';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

class ScreenCapture {
  CameraController? _controller;
  bool _isInitialized = false;
  Timer? _captureTimer;
  final Function(Uint8List)? onFrame;

  ScreenCapture({this.onFrame});

  Future<void> initialize() async {
    final cameras = await availableCameras();
    CameraDescription screenCamera;
    try {
      screenCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
      throw Exception('No cameras available');
    }

    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Camera permission not granted');
    }

    _controller = CameraController(
      screenCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  Future<void> startCapture({double fps = 0.5}) async {
    if (!_isInitialized) await initialize();

    _captureTimer = Timer.periodic(Duration(milliseconds: (1000 / fps).round()), (_) async {
      if (_controller!.value.isInitialized) {
        final image = await _controller!.takePicture();
        final bytes = await image.readAsBytes();
        onFrame?.call(bytes);
      }
    });
  }

  void stopCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
  }

  void dispose() {
    stopCapture();
    _controller?.dispose();
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;
}