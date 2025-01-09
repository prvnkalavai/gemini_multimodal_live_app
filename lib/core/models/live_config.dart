// lib/core/models/live_config.dart
import 'package:json_annotation/json_annotation.dart';
import 'live_message.dart';

part 'live_config.g.dart';

@JsonSerializable(explicitToJson: true)
class LiveConfig {
  final String model;
  final SystemInstruction? systemInstruction;
  final LiveGenerationConfig? generationConfig;
  final List<dynamic>? tools;

  LiveConfig({
    required this.model,
    this.systemInstruction,
    this.generationConfig,
    this.tools,
  });

  Map<String, dynamic> toJson() => _$LiveConfigToJson(this);
    factory LiveConfig.fromJson(Map<String, dynamic> json) => _$LiveConfigFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SystemInstruction {
  final List<MessagePart> parts;

  SystemInstruction({required this.parts});

  Map<String, dynamic> toJson() => _$SystemInstructionToJson(this);
  factory SystemInstruction.fromJson(Map<String, dynamic> json) => _$SystemInstructionFromJson(json);
}


@JsonSerializable(explicitToJson: true)
class LiveGenerationConfig {
  final String responseModalities;
  final SpeechConfig? speechConfig;
  // Add other properties as needed

  LiveGenerationConfig({required this.responseModalities, this.speechConfig});

  Map<String, dynamic> toJson() => _$LiveGenerationConfigToJson(this);
    factory LiveGenerationConfig.fromJson(Map<String, dynamic> json) => _$LiveGenerationConfigFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SpeechConfig {
  final VoiceConfig? voiceConfig;

  SpeechConfig({this.voiceConfig});

  Map<String, dynamic> toJson() => _$SpeechConfigToJson(this);
  factory SpeechConfig.fromJson(Map<String, dynamic> json) => _$SpeechConfigFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class VoiceConfig {
  final PrebuiltVoiceConfig? prebuiltVoiceConfig;

  VoiceConfig({this.prebuiltVoiceConfig});

  Map<String, dynamic> toJson() => _$VoiceConfigToJson(this);
  factory VoiceConfig.fromJson(Map<String, dynamic> json) => _$VoiceConfigFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class PrebuiltVoiceConfig {
  final String voiceName;

  PrebuiltVoiceConfig({required this.voiceName});

  Map<String, dynamic> toJson() => _$PrebuiltVoiceConfigToJson(this);
    factory PrebuiltVoiceConfig.fromJson(Map<String, dynamic> json) => _$PrebuiltVoiceConfigFromJson(json);
}