import 'dart:convert';
import 'package:medicine_server/src/data/repository/message_repository.dart';
import 'package:medicine_server/src/data/factory_requests/message_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageWsHandler {
  MessageWsHandler({required IMessageRepository messageRepository})
    : _messageRepository = messageRepository;

  final IMessageRepository _messageRepository;

  Future<void> messageHandler(
    Map<String, dynamic> json,
    WebSocketChannel ws,
  ) async {
    final response = MessageRequstHandler.fromJson(json);
    switch (response) {
      case NewMessageRequest newMessage:
        await _messageRepository.saveMessage(message: newMessage.message);
        ws.sink.add(
          jsonEncode({
            'type': MessaheRequestType.newMessage.value,
            'message': newMessage.message.toJson(),
          }),
        );
      case MessageUpdateRequest messageUpdate:
        await _messageRepository.updateMessage(message: messageUpdate.message);
        ws.sink.add({
          'type': MessaheRequestType.messageUpdate.value,
          'message': messageUpdate.message.toJson(),
        });
      case MessageDeleteRequest messageDelete:
        await _messageRepository.deleteMessage(
          chatId: messageDelete.message.chatId,
          messageId: messageDelete.message.id,
        );
        ws.sink.add({
          'type': MessaheRequestType.messageDelete.value,
          'message': messageDelete.message.toJson(),
        });
      case MessageErrorRequest messageError:
        ws.sink.add({
          'type': MessaheRequestType.messageError.value,
          'error': messageError.error,
        });
    }
  }
}
