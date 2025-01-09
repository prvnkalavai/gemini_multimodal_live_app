import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/contexts/live_api_context.dart';
import 'package:gemini_multimodal_live_app/core/models/live_config.dart';
import 'package:gemini_multimodal_live_app/core/models/live_message.dart';

class MultimodalLiveClient {
  final BuildContext context;

  MultimodalLiveClient({required this.context});

  void initialize(String modelName) {
    LiveAPIContext.setConfig(
      context,
      LiveConfig(
        model: modelName,
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
  }

  void sendUserMessage(String message) {
      if(message.isNotEmpty){
          LiveAPIContext.sendClientContent(
            context,
            ClientContent(
            turns: [Content(role: 'user', parts: [MessagePart(text: message)])],
            turnComplete: true,
        ),
      );
       }

  }

  void sendAudioChunk(String base64Audio) {
    LiveAPIContext.sendRealtimeInput(
      context,
      RealtimeInput(
        mediaChunks: [
          GenerativeContentBlob(mimeType: 'audio/webm', data: base64Audio),
        ],
      ),
    );
  }

  // Add more methods for interacting with the live API
}