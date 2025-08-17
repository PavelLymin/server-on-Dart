import 'dart:convert';
import 'package:medicine_server/src/router/ws/chat/chat_ws_handler.dart';
import 'package:medicine_server/src/router/ws/message/message_ws_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
part 'connection_ws_handler.g.dart';

class ConnectionWsHandler {
  ConnectionWsHandler({
    required MessageWsHandler messageWsHandler,
    required ChatWsHandler chatWsHandler,
  }) : _messageWsHandler = messageWsHandler,
       _chatWsHandler = chatWsHandler;

  final MessageWsHandler _messageWsHandler;

  final ChatWsHandler _chatWsHandler;

  final _chatMembers = <int, Set<WebSocketChannel>>{};

  Router get router => _$ConnectionWsHandlerRouter(this);

  @Route.get('/ws/connection')
  Future<Response> connect(Request request) async {
    return webSocketHandler((ws, _) {
      ws.stream.listen(
        (message) {
          try {
            final json = jsonDecode(message) as Map<String, dynamic>;

            _messageWsHandler.messageHandler(json, ws);

            _chatWsHandler.chatHandler(json, ws, _chatMembers);
          } catch (error, stackTrace) {
            ws.sink.add(
              jsonEncode({
                'message': 'Invalid message format ',
                'error': error.toString(),
                'stackTrace': stackTrace.toString(),
              }),
            );
          }
        },
        onDone: () {
          for (var set in _chatMembers.values) {
            set.removeWhere((client) => identical(ws, client));
          }
          ws.sink.close();
        },
        onError: (error, stackTrace) {
          ws.sink.add(
            jsonEncode({
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
