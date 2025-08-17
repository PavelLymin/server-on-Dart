import 'package:medicine_server/src/data/factory_requests/chat_requests.dart';
import 'package:medicine_server/src/data/repository/chat_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWsHandler {
  ChatWsHandler({required IChatRepository chatRepository})
    : _chatRepository = chatRepository;

  final IChatRepository _chatRepository;

  Future<void> chatHandler(
    Map<String, dynamic> json,
    WebSocketChannel ws,
    Map<int, Set<WebSocketChannel>> chatMembers,
  ) async {
    final response = ChatRequestHandler.fromJson(json);
    switch (response) {
      case CreateChatRequest newChat:
        await _chatRepository.createChat(chat: newChat.chat);

        ws.sink.add({
          'type': ChatRequestType.create.value,
          'chat': newChat.chat.toJson(),
        });
      case ConnectToChatRequest connect:
        chatMembers[connect.chatId] == null
            ? chatMembers[connect.chatId] = Set.from({ws})
            : chatMembers[connect.chatId]!.add(ws);
      case DeleteChatRequest chatDelete:
        await _chatRepository.deleteChat(chatId: chatDelete.chatId);

        chatMembers.remove(chatDelete.chatId);

        ws.sink.add({
          'type': ChatRequestType.delete.value,
          'chatId': chatDelete.chatId,
        });
      case ErrorChatRequest chatError:
        ws.sink.add({
          'type': ChatRequestType.error.value,
          'error': chatError.error,
        });
    }
  }
}
