import 'package:medicine_server/src/router/message_handler/message_handler.dart';
import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/data/repository/message_repository.dart';
import 'package:medicine_server/src/router/ws/connection/connection_ws_handler.dart';

class DepenciesContainer {
  const DepenciesContainer({
    required this.database,
    required this.messageRepository,
    required this.messageHandler,
    required this.connectionWsHandler,
  });

  final AppDatabase database;
  final IMessageRepository messageRepository;
  final MessageHandler messageHandler;
  final ConnectionWsHandler connectionWsHandler;
}
