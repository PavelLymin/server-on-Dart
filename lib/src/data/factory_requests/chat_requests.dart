import 'package:medicine_server/src/model/chat.dart';

enum ChatRequestType {
  create('create'),
  delete('delete');

  const ChatRequestType(this.value);
  final String value;

  factory ChatRequestType.fromString(String? value) {
    return ChatRequestType.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () =>
          throw ArgumentError('Unknown message response type: $value'),
    );
  }
}

sealed class ChatRequestHandler {
  const ChatRequestHandler({required this.type});

  final ChatRequestType type;

  factory ChatRequestHandler.fromJson(Map<String, dynamic> json) {
    final type = ChatRequestType.fromString(json['type']);

    return switch (type) {
      ChatRequestType.create => CreateChatRequest.fromJson(json),
      ChatRequestType.delete => DeleteChatRequest.fromJson(json),
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
