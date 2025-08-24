import 'dart:convert';
import 'package:medicine_server/src/data/repository/chat_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/factory_requests/precent_request.dart';

class PrecentWsHandler {
  PrecentWsHandler({required IChatRepository chatRepository})
    : _chatRepository = chatRepository;

  final IChatRepository _chatRepository;

  Future<void> precentHandler(
    Map<String, dynamic> json,
    WebSocketChannel ws,
    Map<String, WebSocketChannel> clients,
  ) async {
    final response = PrecentRequestHandler.fromJson(json);

    switch (response) {
      case StartTyping startTyping:
        final chatMembers = await _chatRepository.fetchChatMembers(
          chatId: startTyping.chatId,
        );

        for (var client in chatMembers) {
          if (client == startTyping.userId) continue;

          clients[client]?.sink.add(
            jsonEncode({
              'type': PrecentState.startTyping.value,
              'chat_id': startTyping.chatId,
            }),
          );
        }
      case StopTyping stopTyping:
        final chatMembers = await _chatRepository.fetchChatMembers(
          chatId: stopTyping.chatId,
        );

        for (var client in chatMembers) {
          if (client == stopTyping.userId) continue;

          clients[client]?.sink.add(
            jsonEncode({
              'type': PrecentState.stopTyping.value,
              'chat_id': stopTyping.chatId,
            }),
          );
        }
    }
  }
}
