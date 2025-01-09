// lib/components/side_panel.dart
import 'package:flutter/material.dart';
import 'package:gemini_multimodal_live_app/components/logger.dart';
import 'package:gemini_multimodal_live_app/contexts/live_api_context.dart';
import 'package:gemini_multimodal_live_app/core/models/live_config.dart';
import 'package:gemini_multimodal_live_app/core/models/live_message.dart'; // Import necessary models

class SidePanel extends StatefulWidget {
  const SidePanel({super.key});

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  final TextEditingController _inputController = TextEditingController();
  String _selectedModel = 'models/gemini-2.0-flash-exp'; // Default value
  String _systemInstruction =
      'You are my helpful assistant. Any time I ask you for a graph call the "render_altair" function I have provided you. Dont ask for additional information just make your best judgement.';
  bool _isExpanded = true;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 300 : 50,
      color: Colors.grey[900],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!_isExpanded) {
            return Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () => setState(() => _isExpanded = true),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              
              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Model dropdown
                        _buildModelDropdown(),
                        const SizedBox(height: 16),
                        
                        // System instruction
                        _buildSystemInstructionField(),
                        const SizedBox(height: 16),
                        
                        // Config button
                        _buildConfigButton(),
                        const SizedBox(height: 16),
                        
                        // Logger section
                        Container(
                          height: 500, // Adjust as needed
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Logger(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Input field at bottom
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _inputController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _handleSubmit,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => setState(() => _isExpanded = false),
          ),
        ],
      ),
    );
  }

  Widget _buildModelDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedModel,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Model',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
      dropdownColor: Colors.grey[800],
      items: const [
        DropdownMenuItem(
          value: 'models/gemini-2.0-flash-exp',
          child: Text(
            'Gemini 2.0 Flash',
            style: TextStyle(color: Colors.white),
          ),
        ),
        // Add more models as needed
      ],
      onChanged: (String? newValue) {
        setState(() {
          _selectedModel = newValue!;
        });
      },
    );
  }

  Widget _buildSystemInstructionField() {
    return TextFormField(
      controller: TextEditingController(text: _systemInstruction),
      maxLines: 3,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'System Instruction',
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _systemInstruction = value;
      },
    );
  }

  Widget _buildConfigButton() {
    return ElevatedButton(
      onPressed: () {
        LiveAPIContext.setConfig(
          context,
          LiveConfig(
            model: _selectedModel,
            generationConfig: LiveGenerationConfig(
              responseModalities: "audio",
              speechConfig: SpeechConfig(
                voiceConfig: VoiceConfig(
                  prebuiltVoiceConfig:
                      PrebuiltVoiceConfig(voiceName: "Aoede"),
                ),
              ),
            ),
            systemInstruction: SystemInstruction(parts: [
              MessagePart(text: _systemInstruction)
            ]),
            tools: [
              {'googleSearch': {}},
              {
                'functionDeclarations': [
                  {
                    'name': 'render_altair',
                    'description':
                        'Displays an altair graph in json format.',
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Configuration updated')),
        );
      },
      child: const Text('Update Configuration'),
    );
  }

  void _handleSubmit(String value) {
    if (value.isEmpty) return;
    
    print("Sending message: $value");
    _sendMessage(value);
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    
    final content = ClientContent(
      turns: [
        Content(
          role: 'user',
          parts: [MessagePart(text: text)]
        )
      ],
      turnComplete: true
    );
    
    LiveAPIContext.sendClientContent(context, content);
    _inputController.clear(); // Clear input after sending
  }
}
