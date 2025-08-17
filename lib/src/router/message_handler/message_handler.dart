import 'dart:convert';
import 'package:medicine_server/src/data/repository/message_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
part 'message_handler.g.dart';

class MessageHandler {
  const MessageHandler({required IMessageRepository repository})
    : _repository = repository;

  final IMessageRepository _repository;

  Router get router => _$MessageHandlerRouter(this);

  @Route.get('/messages')
  Future<Response> allMessages(Request request) async {
    try {
      final chatId = request.url.queryParameters['chat_id'];
      final result = await _repository.fetchMessages(
        chatId: int.parse(chatId!),
      );

      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      return Response.badRequest(
        body: jsonEncode({
          'message': 'Error to fetch messages',
          'error': e.toString(),
          'stack_trace': s.toString(),
        }),
      );
    }
  }
}
