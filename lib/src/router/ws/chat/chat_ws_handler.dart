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
    Map<String, Set<String>> chatMembers,
  ) async {
    final response = ChatRequestHandler.fromJson(json);
    switch (response) {
      case CreateChatRequest newChat:
        final chat = await _chatRepository.createChat(chat: newChat.chat);

        chatMembers.putIfAbsent(
          chat.id.toString(),
          () => {chat.userId, chat.doctorId},
        );

        ws.sink.add({
          'type': ChatRequestType.create.value,
          'chat': newChat.chat.toJson(),
        });
      case UpdateChatRequest chatUpdate:
        await _chatRepository.updateChat(chat: chatUpdate.chat);
        ws.sink.add({
          'type': ChatRequestType.update.value,
          'chat': chatUpdate.chat.toJson(),
        });
      case DeleteChatRequest chatDelete:
        await _chatRepository.deleteChat(chatId: chatDelete.chatId);

        chatMembers.remove(chatDelete.chatId.toString());

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
