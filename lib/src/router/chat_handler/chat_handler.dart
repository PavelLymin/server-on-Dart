import 'dart:convert';
import 'package:medicine_server/src/data/repository/chat_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
part 'chat_handler.g.dart';

class ChatHandler {
  const ChatHandler({required IChatRepository repository})
    : _repository = repository;

  final IChatRepository _repository;

  Router get router => _$ChatHandlerRouter(this);

  @Route.get('/chats')
  Future<Response> allChats(Request request) async {
    try {
      final userId = request.context['user_id'];
      final result = await _repository.fetchChats(userId: userId! as String);

      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      return Response.badRequest(
        body: jsonEncode({
          'message': 'Error to fetch chats',
          'error': e.toString(),
          'stack_trace': s.toString(),
        }),
      );
    }
  }
}
