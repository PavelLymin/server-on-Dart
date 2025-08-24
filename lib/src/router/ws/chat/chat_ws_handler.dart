import 'package:medicine_server/src/data/factory_requests/chat_requests.dart';
import 'package:medicine_server/src/data/repository/chat_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../connection/connection_ws_handler.dart';

class ChatWsHandler {
  ChatWsHandler({required IChatRepository chatRepository})
    : _chatRepository = chatRepository;

  final IChatRepository _chatRepository;

  Future<void> chatHandler(
    Map<String, dynamic> json,
    WebSocketChannel ws,
    Map<String, WebSocketChannel> clients,
  ) async {
    final response = ChatRequestHandler.fromJson(json);
    switch (response) {
      case CreateChatRequest newChat:
        await _chatRepository.createChat(chat: newChat.chat);

        ws.sink.add({
          'request_type': RequestType.chat.value,
          'type': ChatRequestType.create.value,
          'chat': newChat.chat.toJson(),
        });
      case DeleteChatRequest chatDelete:
        await _chatRepository.deleteChat(chatId: chatDelete.chatId);

        ws.sink.add({
          'request_type': RequestType.chat.value,
          'type': ChatRequestType.delete.value,
          'chatId': chatDelete.chatId,
        });
    }
  }
}
