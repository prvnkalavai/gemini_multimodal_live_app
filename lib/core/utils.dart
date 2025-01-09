// lib/core/utils.dart
import 'dart:convert';
import 'dart:typed_data';

String blobToBase64(Uint8List blob) {
  return base64Encode(blob);
}

Uint8List base64ToBlob(String base64String) {
  return base64Decode(base64String);
}