// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveConfig _$LiveConfigFromJson(Map<String, dynamic> json) => LiveConfig(
      model: json['model'] as String,
      systemInstruction: json['systemInstruction'] == null
          ? null
          : SystemInstruction.fromJson(
              json['systemInstruction'] as Map<String, dynamic>),
      generationConfig: json['generationConfig'] == null
          ? null
          : LiveGenerationConfig.fromJson(
              json['generationConfig'] as Map<String, dynamic>),
      tools: json['tools'] as List<dynamic>?,
    );

Map<String, dynamic> _$LiveConfigToJson(LiveConfig instance) =>
    <String, dynamic>{
      'model': instance.model,
      'systemInstruction': instance.systemInstruction?.toJson(),
      'generationConfig': instance.generationConfig?.toJson(),
      'tools': instance.tools,
    };

SystemInstruction _$SystemInstructionFromJson(Map<String, dynamic> json) =>
    SystemInstruction(
      parts: (json['parts'] as List<dynamic>)
          .map((e) => MessagePart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemInstructionToJson(SystemInstruction instance) =>
    <String, dynamic>{
      'parts': instance.parts.map((e) => e.toJson()).toList(),
    };

LiveGenerationConfig _$LiveGenerationConfigFromJson(
        Map<String, dynamic> json) =>
    LiveGenerationConfig(
      responseModalities: json['responseModalities'] as String,
      speechConfig: json['speechConfig'] == null
          ? null
          : SpeechConfig.fromJson(json['speechConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LiveGenerationConfigToJson(
        LiveGenerationConfig instance) =>
    <String, dynamic>{
      'responseModalities': instance.responseModalities,
      'speechConfig': instance.speechConfig?.toJson(),
    };

SpeechConfig _$SpeechConfigFromJson(Map<String, dynamic> json) => SpeechConfig(
      voiceConfig: json['voiceConfig'] == null
          ? null
          : VoiceConfig.fromJson(json['voiceConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpeechConfigToJson(SpeechConfig instance) =>
    <String, dynamic>{
      'voiceConfig': instance.voiceConfig?.toJson(),
    };

VoiceConfig _$VoiceConfigFromJson(Map<String, dynamic> json) => VoiceConfig(
      prebuiltVoiceConfig: json['prebuiltVoiceConfig'] == null
          ? null
          : PrebuiltVoiceConfig.fromJson(
              json['prebuiltVoiceConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoiceConfigToJson(VoiceConfig instance) =>
    <String, dynamic>{
      'prebuiltVoiceConfig': instance.prebuiltVoiceConfig?.toJson(),
    };

PrebuiltVoiceConfig _$PrebuiltVoiceConfigFromJson(Map<String, dynamic> json) =>
    PrebuiltVoiceConfig(
      voiceName: json['voiceName'] as String,
    );

Map<String, dynamic> _$PrebuiltVoiceConfigToJson(
        PrebuiltVoiceConfig instance) =>
    <String, dynamic>{
      'voiceName': instance.voiceName,
    };
