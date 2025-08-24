import 'dart:convert';
import 'package:medicine_server/src/router/ws/chat/chat_ws_handler.dart';
import 'package:medicine_server/src/router/ws/message/message_ws_handler.dart';
import 'package:medicine_server/src/router/ws/precent/precent_ws_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
part 'connection_ws_handler.g.dart';

enum RequestType {
  message('message'),
  chat('chat'),
  typing('typing');

  const RequestType(this.value);
  final String value;
}

class ConnectionWsHandler {
  ConnectionWsHandler({
    required MessageWsHandler messageWsHandler,
    required ChatWsHandler chatWsHandler,
    required PrecentWsHandler precentWsHandler,
  }) : _messageWsHandler = messageWsHandler,
       _chatWsHandler = chatWsHandler,
       _precentWsHandler = precentWsHandler;

  final MessageWsHandler _messageWsHandler;

  final ChatWsHandler _chatWsHandler;

  final PrecentWsHandler _precentWsHandler;

  final _clients = <String, WebSocketChannel>{};

  Router get router => _$ConnectionWsHandlerRouter(this);

  @Route.get('/connection')
  Future<Response> connect(Request request) async {
    final userId = request.context['user_id'] as String;

    return webSocketHandler((ws, _) {
      _clients[userId] = ws;
      ws.stream.listen(
        (message) {
          try {
            final json = jsonDecode(message) as Map<String, dynamic>;

            if (json['request_type'] == RequestType.message.value) {
              _messageWsHandler.messageHandler(json, ws, _clients);
            } else if (json['request_type'] == RequestType.chat.value) {
              _chatWsHandler.chatHandler(json, ws, _clients);
            } else if (json['request_type'] == RequestType.typing.value) {
              _precentWsHandler.precentHandler(json, ws, _clients);
            }
          } catch (error, stackTrace) {
            ws.sink.add(
              jsonEncode({
                'message': 'Invalid message format',
                'error': error.toString(),
                'stackTrace': stackTrace.toString(),
              }),
            );
          }
        },
        onDone: () {
          _clients.remove(userId);
          ws.sink.close();
        },
        onError: (error, stackTrace) {
          ws.sink.add(
            jsonEncode({
              'type': 'error',
              'message': 'Error ws connection',
              'error': error.toString(),
              'stackTrace': stackTrace.toString(),
            }),
          );
        },
      );
    }).call(request);
  }
}
