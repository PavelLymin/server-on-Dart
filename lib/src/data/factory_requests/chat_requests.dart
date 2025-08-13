import 'package:medicine_server/src/model/chat.dart';

enum ChatRequestType {
  create('create'),
  update('update'),
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

    switch (type) {
      case ChatRequestType.create:
        return CreateChatRequest.fromJson(json);
      case ChatRequestType.update:
        return UpdateChatRequest.fromJson(json);
      case ChatRequestType.delete:
        return DeleteChatRequest.fromJson(json);
      case ChatRequestType.error:
        return ErrorChatRequest.fromJson(json);
    }
  }

  @override
  String toString() => 'ChatResponse(type: $type)';
}

class CreateChatRequest extends ChatRequestHandler {
  const CreateChatRequest({
    required this.chat,
    super.type = ChatRequestType.create,
  });

  final CreatedChat chat;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      CreateChatRequest(chat: CreatedChat.fromJson(json['chat']));

  @override
  String toString() => 'CreateChatResponse(chat: $chat)';
}

class UpdateChatRequest extends ChatRequestHandler {
  const UpdateChatRequest({
    required this.chat,
    super.type = ChatRequestType.update,
  });

  final CreatedChat chat;

  factory UpdateChatRequest.fromJson(Map<String, dynamic> json) =>
      UpdateChatRequest(chat: CreatedChat.fromJson(json['chat']));

  @override
  String toString() => 'UpdateChatResponse(chat: $chat)';
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
