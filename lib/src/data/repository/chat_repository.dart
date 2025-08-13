import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/model/chat.dart';

abstract interface class IChatRepository {
  Future<FullChat> createChat({required CreatedChat chat});

  Future<FullChat> updateChat({required CreatedChat chat});

  Future<FullChat> deleteChat({required int chatId});
}

class ChatRepository implements IChatRepository {
  const ChatRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<FullChat> createChat({required CreatedChat chat}) async {
    final result = await _database
        .into(_database.chats)
        .insertReturning(chat.toCompanion());

    final savedMessage = FullChat.fromCompanion(result);

    return savedMessage;
  }

  @override
  Future<FullChat> deleteChat({required int chatId}) async {
    final result = await (_database.delete(
      _database.chats,
    )..where((chat) => chat.id.equals(chatId))).goAndReturn();

    if (result.isEmpty) {
      throw Exception('Chat not found');
    }

    final deletedChat = FullChat.fromCompanion(result[0]);
    return deletedChat;
  }

  @override
  Future<FullChat> updateChat({required CreatedChat chat}) async {
    final result =
        await (_database.update(_database.chats)
              ..where((chat) => chat.id.equalsExp(chat.id)))
            .writeReturning(chat.toCompanion());

    if (result.isEmpty) {
      throw Exception('Chat not found');
    }

    final updatedChat = FullChat.fromCompanion(result[0]);

    return updatedChat;
  }
}
