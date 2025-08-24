import 'package:medicine_server/src/router/message_handler/message_handler.dart';
import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/router/ws/connection/connection_ws_handler.dart';
import 'package:medicine_server/src/router/ws/message/message_ws_handler.dart';
import '../../data/repository/chat_repository.dart';
import '../../data/repository/message_repository.dart';
import '../../router/chat_handler/chat_handler.dart';
import '../../router/ws/chat/chat_ws_handler.dart';
import '../../router/ws/precent/precent_ws_handler.dart';
import '../dependency/depencies_container.dart';

class CompositionRoot {
  const CompositionRoot();

  Future<DepenciesContainer> compose() async {
    final database = AppDatabase();

    final messageRepository = MessageRepositoryImpl(database: database);
    final messageHandler = MessageHandler(repository: messageRepository);

    final chatRepository = ChatRepository(database: database);
    final chatHandler = ChatHandler(repository: chatRepository);

    final connectionWsHandler = ConnectionWsHandler(
      messageWsHandler: MessageWsHandler(
        messageRepository: messageRepository,
        chatRepository: chatRepository,
      ),
      chatWsHandler: ChatWsHandler(chatRepository: chatRepository),
      precentWsHandler: PrecentWsHandler(chatRepository: chatRepository),
    );

    final dependencies = _DependencyFactory(
      database: database,
      messageRepository: messageRepository,
      messageHandler: messageHandler,
      chatHandler: chatHandler,
      connectionWsHandler: connectionWsHandler,
    ).create();

    return dependencies;
  }
}

abstract class Factory<T> {
  const Factory();

  T create();
}

abstract class AsyncFactory<T> {
  const AsyncFactory();

  Future<T> create();
}

class _DependencyFactory extends Factory<DepenciesContainer> {
  const _DependencyFactory({
    required this.database,
    required this.messageRepository,
    required this.messageHandler,
    required this.chatHandler,
    required this.connectionWsHandler,
  });

  final AppDatabase database;
  final IMessageRepository messageRepository;
  final MessageHandler messageHandler;
  final ChatHandler chatHandler;
  final ConnectionWsHandler connectionWsHandler;
  @override
  DepenciesContainer create() => DepenciesContainer(
    database: database,
    messageRepository: messageRepository,
    messageHandler: messageHandler,
    chatHandler: chatHandler,
    connectionWsHandler: connectionWsHandler,
  );
}
