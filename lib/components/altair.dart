import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/contexts/live_api_context.dart';
import 'package:gemini_multimodal_live_app/core/models/live_config.dart';
import 'package:gemini_multimodal_live_app/core/models/live_message.dart';
import 'package:gemini_multimodal_live_app/lib/audio_streamer.dart';
import 'package:flutter_sound/flutter_sound.dart'; 
import 'dart:typed_data';
import 'package:logger/logger.dart';

class Altair extends StatefulWidget {
  const Altair({super.key});

  @override
  State<Altair> createState() => _AltairState();
}

class _AltairState extends State<Altair> {
  String _jsonString = '';
  final _logger = Logger();
  AudioStreamer? _audioStreamer;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    _mounted = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAudioStreamer();
    LiveAPIContext.setOnAudioData(context, (data) {
      // Handle incoming audio data
      if (_audioStreamer != null) {
        final byteData = Uint8List.fromList(data);
        _audioStreamer?.play(byteData);
        _logger.i('received audio data ${byteData.length}');
      } else {
        _logger.e('audio streamer not initialized');
      }
    });
    LiveAPIContext.setConfig(
      context,
      LiveConfig(
        model: "models/gemini-2.0-flash-exp",
        generationConfig: LiveGenerationConfig(
          responseModalities: "audio",
          speechConfig: SpeechConfig(
            voiceConfig: VoiceConfig(
              prebuiltVoiceConfig: PrebuiltVoiceConfig(voiceName: "Aoede"),
            ),
          ),
        ),
        systemInstruction: SystemInstruction(
          parts: [
            MessagePart(
              text:
                  'You are my helpful assistant. Any time I ask you for a graph call the "render_altair" function I have provided you. Dont ask for additional information just make your best judgement.',
            ),
          ],
        ),
        tools: [
          {'googleSearch': {}},
          {
            'functionDeclarations': [
              {
                'name': 'render_altair',
                'description': 'Displays an altair graph in json format.',
                'parameters': {
                  'type': 'OBJECT',
                  'properties': {
                    'json_graph': {
                      'type': 'STRING',
                      'description':
                          'JSON STRING representation of the graph to render. Must be a string, not a json object',
                    },
                  },
                  'required': ['json_graph'],
                },
              }
            ]
          }
        ],
      ),
    );

    LiveAPIContext.setOnToolCall(context, (toolCall) {
      _logger.i('got toolcall: ${toolCall.toString()}');
      final fc = toolCall.functionCalls.firstWhere(
        (fc) => fc.name == 'render_altair',
        orElse: () => LiveFunctionCall(name: '', args: {}, id: ''),
      );
      if (fc.name.isNotEmpty) {
        if (_mounted) {
          setState(() {
            _jsonString = fc.args['json_graph'];
          });
        }
      }
      if (toolCall.functionCalls.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (_mounted) {
            LiveAPIContext.sendToolResponse(
              context,
              ToolResponse(
                functionResponses: toolCall.functionCalls
                    .map(
                      (fc) => LiveFunctionResponse(
                        response: {
                          'output': {'sucess': true}
                        },
                        id: fc.id,
                      ),
                    )
                    .toList(),
              ),
            );
          }
        });
      }
    });
    LiveAPIContext.setOnAudioStreamerReady(context, true);    
  }

  Future<void> _initAudioStreamer() async {
    final session = await FlutterSoundPlayer().openPlayer();
    _audioStreamer = AudioStreamer(
      context: session!,
      onComplete: () {
        _logger.i("playback complete");
      },
    );
    await _audioStreamer!.init();
    await _audioStreamer!.resume();
  }

  @override
  Widget build(BuildContext context) {
// Provide UI for displaying the Altair graph
    return Container(
      color: Colors.black,
      width: double.infinity,
      height: double.infinity,
      child: Text(
        _jsonString.isEmpty
            ? 'No Altair graph to display...'
            : 'Render Altair here:\n$_jsonString',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _mounted = false;

    _audioStreamer?.dispose();
    super.dispose();
  }
}
