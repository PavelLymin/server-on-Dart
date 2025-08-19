import 'package:medicine_server/src/model/message.dart';

enum MessageRequestType {
  newMessage('message_send'),
  messageUpdate('message_update'),
  messageDelete('message_delete'),
  messageError('message_error');

  const MessageRequestType(this.value);
  final String value;

  factory MessageRequestType.fromString(String value) =>
      MessageRequestType.values.firstWhere(
        (type) => type.value == value.trim().toLowerCase(),
        orElse: () =>
            throw ArgumentError('Unknown message request type: $value'),
      );
}

sealed class MessageRequstHandler {
  const MessageRequstHandler({required this.type});

  final MessageRequestType type;

  factory MessageRequstHandler.fromJson(Map<String, dynamic> json) {
    final type = MessageRequestType.fromString(json['type']);

    switch (type) {
      case MessageRequestType.newMessage:
        return NewMessageRequest.fromJson(json);
      case MessageRequestType.messageUpdate:
        return MessageUpdateRequest.fromJson(json);
      case MessageRequestType.messageDelete:
        return MessageDeleteRequest.fromJson(json);
      case MessageRequestType.messageError:
        return MessageErrorRequest.fromJson(json);
    }
  }

  @override
  String toString() => 'ChatResponse(type: $type)';
}

class NewMessageRequest extends MessageRequstHandler {
  const NewMessageRequest({
    required this.message,
    super.type = MessageRequestType.newMessage,
  });

  final CreatedMessage message;

  factory NewMessageRequest.fromJson(Map<String, dynamic> json) =>
      NewMessageRequest(
        message: CreatedMessage.fromJson(
          json['message'] as Map<String, dynamic>,
        ),
      );

  @override
  String toString() => 'NewMessageResponse(message: $message)';
}

class MessageUpdateRequest extends MessageRequstHandler {
  const MessageUpdateRequest({
    required this.message,
    super.type = MessageRequestType.messageUpdate,
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
    super.type = MessageRequestType.messageDelete,
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
    super.type = MessageRequestType.messageError,
  });

  final String error;

  factory MessageErrorRequest.fromJson(Map<String, dynamic> json) =>
      MessageErrorRequest(error: json['error'] as String);

  @override
  String toString() => 'MessageErrorResponse(error: $error)';
}
