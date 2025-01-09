// lib/store_logger.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StoreLogger {
  static final StoreLogger _instance = StoreLogger._internal();
  factory StoreLogger() => _instance;
  StoreLogger._internal();

  File? _logFile;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/app.log');
    if (!await _logFile!.exists()) {
      await _logFile!.create();
    }
  }

  Future<void> log(String message) async {
    if (_logFile == null) {
      await init();
    }
    final timestamp = DateTime.now().toIso8601String();
    await _logFile!.writeAsString('$timestamp: $message\n', mode: FileMode.append);
  }

  Future<String> readLog() async {
    if (_logFile == null) {
      await init();
    }
    return await _logFile!.readAsString();
  }
}