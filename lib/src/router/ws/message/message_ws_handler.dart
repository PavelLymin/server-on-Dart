import 'dart:convert';
import 'package:medicine_server/src/data/repository/chat_repository.dart';
import 'package:medicine_server/src/data/repository/message_repository.dart';
import 'package:medicine_server/src/data/factory_requests/message_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../connection/connection_ws_handler.dart';

enum MessageResponseType {
  newMessage('new_message'),
  messageUpdate('updated_message'),
  messageDelete('deleted_message'),
  messageError('error');

  const MessageResponseType(this.value);

  final String value;
}

class MessageWsHandler {
  MessageWsHandler({
    required IMessageRepository messageRepository,
    required IChatRepository chatRepository,
  }) : _messageRepository = messageRepository,
       _chatRepository = chatRepository;

  final IMessageRepository _messageRepository;
  final IChatRepository _chatRepository;

  Future<void> messageHandler(
    Map<String, dynamic> json,
    WebSocketChannel ws,
    Map<String, WebSocketChannel> clients,
  ) async {
    final response = MessageRequstHandler.fromJson(json);
    switch (response) {
      case NewMessageRequest newMessage:
        final savedMessage = await _messageRepository.saveMessage(
          message: newMessage.message,
        );

        final chatMembers = await _chatRepository.fetchChatMembers(
          chatId: savedMessage.chatId,
        );

        for (var client in chatMembers) {
          clients[client]?.sink.add(
            jsonEncode({
              'request_type': RequestType.message.value,
              'type': MessageResponseType.newMessage.value,
              'message': savedMessage.toJson(),
              'chat_id': savedMessage.chatId,
            }),
          );
        }
      case MessageUpdateRequest messageUpdate:
        final updatedMessage = await _messageRepository.updateMessage(
          message: messageUpdate.message,
        );

        final chatMembers = await _chatRepository.fetchChatMembers(
          chatId: updatedMessage.chatId,
        );

        for (var client in chatMembers) {
          clients[client]?.sink.add(
            jsonEncode({
              'request_type': RequestType.message.value,
              'type': MessageResponseType.messageUpdate.value,
              'message': updatedMessage.toJson(),
            }),
          );
        }
      case MessageDeleteRequest messageDelete:
        final deletedMessage = await _messageRepository.deleteMessage(
          messageId: messageDelete.messageId,
          chatId: messageDelete.chatId,
        );
        ws.sink.add({
          'request_type': RequestType.message.value,
          'type': MessageResponseType.messageDelete.value,
          'message_id': messageDelete.messageId,
          'chat_id': deletedMessage.chatId,
        });
    }
  }
}
