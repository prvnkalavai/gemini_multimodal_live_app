// lib/core/models/live_message.dart
// Define data models for incoming and outgoing messages
import 'package:json_annotation/json_annotation.dart';
import 'live_config.dart';

part 'live_message.g.dart';

@JsonSerializable()
class MessagePart {
  final String? text;
  final InlineData? inlineData;

  MessagePart({this.text, this.inlineData});

  factory MessagePart.fromJson(Map<String, dynamic> json) => _$MessagePartFromJson(json);
  Map<String, dynamic> toJson() => _$MessagePartToJson(this);
}

@JsonSerializable()
class InlineData {
  final String mimeType;
  final String data;

  InlineData({required this.mimeType, required this.data});

  factory InlineData.fromJson(Map<String, dynamic> json) => _$InlineDataFromJson(json);
  Map<String, dynamic> toJson() => _$InlineDataToJson(this);
}


// Outgoing Messages

@JsonSerializable()
class SetupMessage {
  final LiveConfig setup;

  SetupMessage({required this.setup});

  Map<String, dynamic> toJson() => _$SetupMessageToJson(this);
    factory SetupMessage.fromJson(Map<String, dynamic> json) => _$SetupMessageFromJson(json);

}

@JsonSerializable()
class ClientContentMessage {
  final ClientContent clientContent;

  ClientContentMessage({required this.clientContent});

  Map<String, dynamic> toJson() => _$ClientContentMessageToJson(this);
    factory ClientContentMessage.fromJson(Map<String, dynamic> json) => _$ClientContentMessageFromJson(json);
}

@JsonSerializable()
class ClientContent {
  final List<Content> turns;
  final bool turnComplete;

  ClientContent({required this.turns, required this.turnComplete});

  Map<String, dynamic> toJson() => _$ClientContentToJson(this);
    factory ClientContent.fromJson(Map<String, dynamic> json) => _$ClientContentFromJson(json);
}

@JsonSerializable()
class Content {
  final String role;
  final List<MessagePart> parts;

  Content({required this.role, required this.parts});

  Map<String, dynamic> toJson() => _$ContentToJson(this);
   factory Content.fromJson(Map<String, dynamic> json) => _$ContentFromJson(json);
}

@JsonSerializable()
class RealtimeInputMessage {
  final RealtimeInput realtimeInput;

  RealtimeInputMessage({required this.realtimeInput});

  Map<String, dynamic> toJson() => _$RealtimeInputMessageToJson(this);
    factory RealtimeInputMessage.fromJson(Map<String, dynamic> json) => _$RealtimeInputMessageFromJson(json);
}

@JsonSerializable()
class RealtimeInput {
  final List<GenerativeContentBlob> mediaChunks;

  RealtimeInput({required this.mediaChunks});

  Map<String, dynamic> toJson() => _$RealtimeInputToJson(this);
    factory RealtimeInput.fromJson(Map<String, dynamic> json) => _$RealtimeInputFromJson(json);
}

@JsonSerializable()
class GenerativeContentBlob {
  final String mimeType;
  final String data;

  GenerativeContentBlob({required this.mimeType, required this.data});

  Map<String, dynamic> toJson() => _$GenerativeContentBlobToJson(this);
    factory GenerativeContentBlob.fromJson(Map<String, dynamic> json) => _$GenerativeContentBlobFromJson(json);
}

@JsonSerializable()
class ToolResponseMessage {
  final ToolResponse toolResponse;

  ToolResponseMessage({required this.toolResponse});

  Map<String, dynamic> toJson() => _$ToolResponseMessageToJson(this);
  factory ToolResponseMessage.fromJson(Map<String, dynamic> json) => _$ToolResponseMessageFromJson(json);
}

@JsonSerializable()
class ToolResponse {
  final List<LiveFunctionResponse> functionResponses;

  ToolResponse({required this.functionResponses});

  Map<String, dynamic> toJson() => _$ToolResponseToJson(this);
    factory ToolResponse.fromJson(Map<String, dynamic> json) => _$ToolResponseFromJson(json);
}

@JsonSerializable()
class LiveFunctionResponse {
  final Map<String, dynamic> response;
  final String id;

  LiveFunctionResponse({required this.response, required this.id});

  Map<String, dynamic> toJson() => _$LiveFunctionResponseToJson(this);
    factory LiveFunctionResponse.fromJson(Map<String, dynamic> json) => _$LiveFunctionResponseFromJson(json);
}

// Incoming Messages

@JsonSerializable()
class LiveIncomingMessage {
  final SetupCompleteMessage? setupComplete;
  final ServerContentMessage? serverContent;
  final ToolCallMessage? toolCall;
  final ToolCallCancellationMessage? toolCallCancellation;

  LiveIncomingMessage({
    this.setupComplete,
    this.serverContent,
    this.toolCall,
    this.toolCallCancellation,
  });

  factory LiveIncomingMessage.fromJson(Map<String, dynamic> json) =>
      _$LiveIncomingMessageFromJson(json);
}

@JsonSerializable()
class SetupCompleteMessage {
  SetupCompleteMessage();

  factory SetupCompleteMessage.fromJson(Map<String, dynamic> json) =>
      _$SetupCompleteMessageFromJson(json);
        Map<String, dynamic> toJson() => _$SetupCompleteMessageToJson(this);

}

@JsonSerializable()
class ServerContentMessage {
  final ServerContent serverContent;

  ServerContentMessage({required this.serverContent});

  factory ServerContentMessage.fromJson(Map<String, dynamic> json) =>
      _$ServerContentMessageFromJson(json);
        Map<String, dynamic> toJson() => _$ServerContentMessageToJson(this);

}

@JsonSerializable()
class ServerContent {
  final ModelTurn? modelTurn;
  final bool? turnComplete;
  final bool? interrupted;

  ServerContent({this.modelTurn, this.turnComplete, this.interrupted});

  factory ServerContent.fromJson(Map<String, dynamic> json) =>
      _$ServerContentFromJson(json);
        Map<String, dynamic> toJson() => _$ServerContentToJson(this);

}

@JsonSerializable()
class ModelTurn {
  final List<MessagePart> parts;

  ModelTurn({required this.parts});

  factory ModelTurn.fromJson(Map<String, dynamic> json) =>
      _$ModelTurnFromJson(json);
      Map<String, dynamic> toJson() => _$ModelTurnToJson(this);
}

@JsonSerializable()
class ToolCallMessage {
  final ToolCall toolCall;

  ToolCallMessage({required this.toolCall});

  factory ToolCallMessage.fromJson(Map<String, dynamic> json) =>
      _$ToolCallMessageFromJson(json);
        Map<String, dynamic> toJson() => _$ToolCallMessageToJson(this);

}

@JsonSerializable()
class ToolCall {
  final List<LiveFunctionCall> functionCalls;

  ToolCall({required this.functionCalls});

  factory ToolCall.fromJson(Map<String, dynamic> json) => _$ToolCallFromJson(json);
    Map<String, dynamic> toJson() => _$ToolCallToJson(this);

}

@JsonSerializable()
class LiveFunctionCall {
  final String name;
  final Map<String, dynamic> args;
  final String id;

  LiveFunctionCall({required this.name, required this.args, required this.id});

  factory LiveFunctionCall.fromJson(Map<String, dynamic> json) =>
      _$LiveFunctionCallFromJson(json);
      Map<String, dynamic> toJson() => _$LiveFunctionCallToJson(this);
}

@JsonSerializable()
class ToolCallCancellationMessage {
  final ToolCallCancellation toolCallCancellation;

  ToolCallCancellationMessage({required this.toolCallCancellation});

  factory ToolCallCancellationMessage.fromJson(Map<String, dynamic> json) =>
      _$ToolCallCancellationMessageFromJson(json);
       Map<String, dynamic> toJson() => _$ToolCallCancellationMessageToJson(this);

}

@JsonSerializable()
class ToolCallCancellation {
  final List<String> ids;

  ToolCallCancellation({required this.ids});

  factory ToolCallCancellation.fromJson(Map<String, dynamic> json) =>
      _$ToolCallCancellationFromJson(json);
    Map<String, dynamic> toJson() => _$ToolCallCancellationToJson(this);
}