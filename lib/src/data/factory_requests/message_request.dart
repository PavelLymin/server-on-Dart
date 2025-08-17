import 'package:medicine_server/src/model/message.dart';

enum MessaheRequestType {
  newMessage('new_message'),
  messageUpdate('message_update'),
  messageDelete('message_delete'),
  messageError('message_error');

  const MessaheRequestType(this.value);
  final String value;
}

sealed class MessageRequstHandler {
  const MessageRequstHandler({required this.type});

  final MessaheRequestType type;

  factory MessageRequstHandler.fromJson(Map<String, dynamic> json) {
    final type = MessaheRequestType.values.firstWhere(
      (e) => e.value == json['type'] as String,
      orElse: () => throw ArgumentError('Unknown type: ${json['type']}'),
    );

    switch (type) {
      case MessaheRequestType.newMessage:
        return NewMessageRequest.fromJson(json);
      case MessaheRequestType.messageUpdate:
        return MessageUpdateRequest.fromJson(json);
      case MessaheRequestType.messageDelete:
        return MessageDeleteRequest.fromJson(json);
      case MessaheRequestType.messageError:
        return MessageErrorRequest.fromJson(json);
    }
  }

  @override
  String toString() => 'ChatResponse(type: $type)';
}

class NewMessageRequest extends MessageRequstHandler {
  const NewMessageRequest({
    required this.message,
    super.type = MessaheRequestType.newMessage,
  });

  final CreatedMessage message;

  factory NewMessageRequest.fromJson(Map<String, dynamic> json) =>
      NewMessageRequest(message: CreatedMessage.fromJson(json['message']));

  @override
  String toString() => 'NewMessageResponse(message: $message)';
}

class MessageUpdateRequest extends MessageRequstHandler {
  const MessageUpdateRequest({
    required this.message,
    super.type = MessaheRequestType.messageUpdate,
  });

  final CreatedMessage message;

  factory MessageUpdateRequest.fromJson(Map<String, dynamic> json) =>
      MessageUpdateRequest(message: CreatedMessage.fromJson(json['message']));

  @override
  String toString() => 'MessageUpdateResponse(message: $message)';
}

class MessageDeleteRequest extends MessageRequstHandler {
  const MessageDeleteRequest({
    required this.messageId,
    required this.chatId,
    super.type = MessaheRequestType.messageDelete,
  });

  final int messageId;
  final int chatId;

  factory MessageDeleteRequest.fromJson(Map<String, dynamic> json) =>
      MessageDeleteRequest(
        messageId: json['message_id'] as int,
        chatId: json['chat_id'] as int,
      );

  @override
  String toString() =>
      'MessageDeleteResponse(messageId: $messageId, chatId: $chatId)';
}

class MessageErrorRequest extends MessageRequstHandler {
  const MessageErrorRequest({
    required this.error,
    super.type = MessaheRequestType.messageError,
  });

  final String error;

  factory MessageErrorRequest.fromJson(Map<String, dynamic> json) =>
      MessageErrorRequest(error: json['error'] as String);

  @override
  String toString() => 'MessageErrorResponse(error: $error)';
}
