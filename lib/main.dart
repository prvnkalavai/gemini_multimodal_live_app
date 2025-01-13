// lib/main.dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

void main() async {
  String envFile =  kIsWeb ? ".env" : ".env";
  await dotenv.load(fileName: envFile);
  runApp(const MyApp());
}


