import 'package:medicine_server/src/model/chat.dart';

enum ChatRequestType {
  create('create'),
  connect('connect'),
  delete('delete'),
  error('error');

  const ChatRequestType(this.value);
  final String value;
}

sealed class ChatRequestHandler {
  const ChatRequestHandler({required this.type});

  final ChatRequestType type;

  factory ChatRequestHandler.fromJson(Map<String, dynamic> json) {
    final type = ChatRequestType.values.firstWhere(
      (e) => e.value == json['type'] as String,
      orElse: () => throw ArgumentError('Unknown type: ${json['type']}'),
    );

    return switch (type) {
      ChatRequestType.create => CreateChatRequest.fromJson(json),
      ChatRequestType.connect => ConnectToChatRequest.fromJson(json),
      ChatRequestType.delete => DeleteChatRequest.fromJson(json),
      ChatRequestType.error => ErrorChatRequest.fromJson(json),
    };
  }

  @override
  String toString() => 'ChatResponse(type: $type)';
}

class CreateChatRequest extends ChatRequestHandler {
  const CreateChatRequest({
    required this.chat,
    super.type = ChatRequestType.create,
  });

  final CreatedChatEntity chat;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      CreateChatRequest(chat: CreatedChatEntity.fromJson(json['chat']));

  @override
  String toString() => 'CreateChatResponse(chat: $chat)';
}

class ConnectToChatRequest extends ChatRequestHandler {
  const ConnectToChatRequest({
    required this.chatId,
    super.type = ChatRequestType.connect,
  });

  final int chatId;

  factory ConnectToChatRequest.fromJson(Map<String, dynamic> json) =>
      ConnectToChatRequest(chatId: json['chat_id'] as int);

  @override
  String toString() => 'ConnectChatResponse(chatId: $chatId)';
}

class DeleteChatRequest extends ChatRequestHandler {
  const DeleteChatRequest({
    required this.chatId,
    super.type = ChatRequestType.delete,
  });

  final int chatId;

  factory DeleteChatRequest.fromJson(Map<String, dynamic> json) =>
      DeleteChatRequest(chatId: json['chat_id'] as int);

  @override
  String toString() => 'DeleteChatResponse(chatId: $chatId)';
}

class ErrorChatRequest extends ChatRequestHandler {
  const ErrorChatRequest({
    required this.error,
    super.type = ChatRequestType.error,
  });

  final String error;

  factory ErrorChatRequest.fromJson(Map<String, dynamic> json) =>
      ErrorChatRequest(error: json['error'] as String);

  @override
  String toString() => 'ErrorChatResponse(error: $error)';
}
