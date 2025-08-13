// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_handler.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$MessageHandlerRouter(MessageHandler service) {
  final router = Router();
  router.add('GET', r'/messages/', service.allMessages);
  return router;
}
