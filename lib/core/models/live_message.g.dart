// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePart _$MessagePartFromJson(Map<String, dynamic> json) => MessagePart(
      text: json['text'] as String?,
      inlineData: json['inlineData'] == null
          ? null
          : InlineData.fromJson(json['inlineData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessagePartToJson(MessagePart instance) =>
    <String, dynamic>{
      'text': instance.text,
      'inlineData': instance.inlineData,
    };

InlineData _$InlineDataFromJson(Map<String, dynamic> json) => InlineData(
      mimeType: json['mimeType'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$InlineDataToJson(InlineData instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
      'data': instance.data,
    };

SetupMessage _$SetupMessageFromJson(Map<String, dynamic> json) => SetupMessage(
      setup: LiveConfig.fromJson(json['setup'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetupMessageToJson(SetupMessage instance) =>
    <String, dynamic>{
      'setup': instance.setup,
    };

ClientContentMessage _$ClientContentMessageFromJson(
        Map<String, dynamic> json) =>
    ClientContentMessage(
      clientContent:
          ClientContent.fromJson(json['clientContent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientContentMessageToJson(
        ClientContentMessage instance) =>
    <String, dynamic>{
      'clientContent': instance.clientContent,
    };

ClientContent _$ClientContentFromJson(Map<String, dynamic> json) =>
    ClientContent(
      turns: (json['turns'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      turnComplete: json['turnComplete'] as bool,
    );

Map<String, dynamic> _$ClientContentToJson(ClientContent instance) =>
    <String, dynamic>{
      'turns': instance.turns,
      'turnComplete': instance.turnComplete,
    };

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      role: json['role'] as String,
      parts: (json['parts'] as List<dynamic>)
          .map((e) => MessagePart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'role': instance.role,
      'parts': instance.parts,
    };

RealtimeInputMessage _$RealtimeInputMessageFromJson(
        Map<String, dynamic> json) =>
    RealtimeInputMessage(
      realtimeInput:
          RealtimeInput.fromJson(json['realtimeInput'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RealtimeInputMessageToJson(
        RealtimeInputMessage instance) =>
    <String, dynamic>{
      'realtimeInput': instance.realtimeInput,
    };

RealtimeInput _$RealtimeInputFromJson(Map<String, dynamic> json) =>
    RealtimeInput(
      mediaChunks: (json['mediaChunks'] as List<dynamic>)
          .map((e) => GenerativeContentBlob.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RealtimeInputToJson(RealtimeInput instance) =>
    <String, dynamic>{
      'mediaChunks': instance.mediaChunks,
    };

GenerativeContentBlob _$GenerativeContentBlobFromJson(
        Map<String, dynamic> json) =>
    GenerativeContentBlob(
      mimeType: json['mimeType'] as String,
      data: json['data'] as String,
    );

Map<String, dynamic> _$GenerativeContentBlobToJson(
        GenerativeContentBlob instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
      'data': instance.data,
    };

ToolResponseMessage _$ToolResponseMessageFromJson(Map<String, dynamic> json) =>
    ToolResponseMessage(
      toolResponse:
          ToolResponse.fromJson(json['toolResponse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToolResponseMessageToJson(
        ToolResponseMessage instance) =>
    <String, dynamic>{
      'toolResponse': instance.toolResponse,
    };

ToolResponse _$ToolResponseFromJson(Map<String, dynamic> json) => ToolResponse(
      functionResponses: (json['functionResponses'] as List<dynamic>)
          .map((e) => LiveFunctionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ToolResponseToJson(ToolResponse instance) =>
    <String, dynamic>{
      'functionResponses': instance.functionResponses,
    };

LiveFunctionResponse _$LiveFunctionResponseFromJson(
        Map<String, dynamic> json) =>
    LiveFunctionResponse(
      response: json['response'] as Map<String, dynamic>,
      id: json['id'] as String,
    );

Map<String, dynamic> _$LiveFunctionResponseToJson(
        LiveFunctionResponse instance) =>
    <String, dynamic>{
      'response': instance.response,
      'id': instance.id,
    };

LiveIncomingMessage _$LiveIncomingMessageFromJson(Map<String, dynamic> json) =>
    LiveIncomingMessage(
      setupComplete: json['setupComplete'] == null
          ? null
          : SetupCompleteMessage.fromJson(
              json['setupComplete'] as Map<String, dynamic>),
      serverContent: json['serverContent'] == null
          ? null
          : ServerContentMessage.fromJson(
              json['serverContent'] as Map<String, dynamic>),
      toolCall: json['toolCall'] == null
          ? null
          : ToolCallMessage.fromJson(json['toolCall'] as Map<String, dynamic>),
      toolCallCancellation: json['toolCallCancellation'] == null
          ? null
          : ToolCallCancellationMessage.fromJson(
              json['toolCallCancellation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LiveIncomingMessageToJson(
        LiveIncomingMessage instance) =>
    <String, dynamic>{
      'setupComplete': instance.setupComplete,
      'serverContent': instance.serverContent,
      'toolCall': instance.toolCall,
      'toolCallCancellation': instance.toolCallCancellation,
    };

SetupCompleteMessage _$SetupCompleteMessageFromJson(
        Map<String, dynamic> json) =>
    SetupCompleteMessage();

Map<String, dynamic> _$SetupCompleteMessageToJson(
        SetupCompleteMessage instance) =>
    <String, dynamic>{};

ServerContentMessage _$ServerContentMessageFromJson(
        Map<String, dynamic> json) =>
    ServerContentMessage(
      serverContent:
          ServerContent.fromJson(json['serverContent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerContentMessageToJson(
        ServerContentMessage instance) =>
    <String, dynamic>{
      'serverContent': instance.serverContent,
    };

ServerContent _$ServerContentFromJson(Map<String, dynamic> json) =>
    ServerContent(
      modelTurn: json['modelTurn'] == null
          ? null
          : ModelTurn.fromJson(json['modelTurn'] as Map<String, dynamic>),
      turnComplete: json['turnComplete'] as bool?,
      interrupted: json['interrupted'] as bool?,
    );

Map<String, dynamic> _$ServerContentToJson(ServerContent instance) =>
    <String, dynamic>{
      'modelTurn': instance.modelTurn,
      'turnComplete': instance.turnComplete,
      'interrupted': instance.interrupted,
    };

ModelTurn _$ModelTurnFromJson(Map<String, dynamic> json) => ModelTurn(
      parts: (json['parts'] as List<dynamic>)
          .map((e) => MessagePart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelTurnToJson(ModelTurn instance) => <String, dynamic>{
      'parts': instance.parts,
    };

ToolCallMessage _$ToolCallMessageFromJson(Map<String, dynamic> json) =>
    ToolCallMessage(
      toolCall: ToolCall.fromJson(json['toolCall'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToolCallMessageToJson(ToolCallMessage instance) =>
    <String, dynamic>{
      'toolCall': instance.toolCall,
    };

ToolCall _$ToolCallFromJson(Map<String, dynamic> json) => ToolCall(
      functionCalls: (json['functionCalls'] as List<dynamic>)
          .map((e) => LiveFunctionCall.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ToolCallToJson(ToolCall instance) => <String, dynamic>{
      'functionCalls': instance.functionCalls,
    };

LiveFunctionCall _$LiveFunctionCallFromJson(Map<String, dynamic> json) =>
    LiveFunctionCall(
      name: json['name'] as String,
      args: json['args'] as Map<String, dynamic>,
      id: json['id'] as String,
    );

Map<String, dynamic> _$LiveFunctionCallToJson(LiveFunctionCall instance) =>
    <String, dynamic>{
      'name': instance.name,
      'args': instance.args,
      'id': instance.id,
    };

ToolCallCancellationMessage _$ToolCallCancellationMessageFromJson(
        Map<String, dynamic> json) =>
    ToolCallCancellationMessage(
      toolCallCancellation: ToolCallCancellation.fromJson(
          json['toolCallCancellation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ToolCallCancellationMessageToJson(
        ToolCallCancellationMessage instance) =>
    <String, dynamic>{
      'toolCallCancellation': instance.toolCallCancellation,
    };

ToolCallCancellation _$ToolCallCancellationFromJson(
        Map<String, dynamic> json) =>
    ToolCallCancellation(
      ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ToolCallCancellationToJson(
        ToolCallCancellation instance) =>
    <String, dynamic>{
      'ids': instance.ids,
    };
