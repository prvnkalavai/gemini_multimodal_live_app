// lib/app.dart
// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_multimodal_live_app/contexts/live_api_context.dart';
import 'package:gemini_multimodal_live_app/lib/audio_streamer.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'components/side_panel.dart';
import 'components/altair.dart';
import 'components/control_tray.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multimodal Live API Console',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Space Mono',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LiveAPIProviderWrapper(),
    );
  }
}

class LiveAPIProviderWrapper extends StatefulWidget {
  const LiveAPIProviderWrapper({super.key});

  @override
  State<LiveAPIProviderWrapper> createState() => _LiveAPIProviderWrapperState();
}

class _LiveAPIProviderWrapperState extends State<LiveAPIProviderWrapper> {
  late final AudioStreamer _audioStreamer;
  bool _audioStreamerReady = false;

  @override
  void initState() {
    super.initState();
    _initAudioStreamer();
  }

  Future<void> _initAudioStreamer() async {
    try {
      final player = FlutterSoundPlayer();
      await player.openPlayer();

      _audioStreamer = AudioStreamer(
          context: player,
          onComplete: () {
            print("Audio playback complete");
          },
          sampleRate: 24000, 
          numChannels: 1);

      await _audioStreamer.init();
      await _audioStreamer.resume();
      setState(() => _audioStreamerReady = true);
      print("Audio streamer initialized and ready: $_audioStreamerReady");
    } catch (e) {
      print("Error initializing audio streamer: $e");
    }
  }

  @override
  void dispose() {
    _audioStreamer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _audioStreamerReady
        ? LiveAPIProvider(
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      url:
          'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent',
      onAudioData: (data) {
        print("Received audio data: ${data.length} bytes");
       _audioStreamer.play(data);
      },
      onAudioComplete: () {
           print("Received complete flag");
            _audioStreamer.process();
          },
       onAudioStreamerReady: _audioStreamerReady,
      child: const StreamingConsole(),
      )
        : const Scaffold(
            body: Center(child: CircularProgressIndicator()),
    );
  }
}

class StreamingConsole extends StatelessWidget {
  const StreamingConsole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure you have a Scaffold here
      body: Row(
        children: [
          const SidePanel(),
          Expanded(
            child: MainContentArea(),
          ),
        ],
      ),
    );
  }
}

class MainContentArea extends StatelessWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Altair()),
          ControlTray(),
        ],
      ),
    );
  }
}