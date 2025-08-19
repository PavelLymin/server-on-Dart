import 'package:drift/drift.dart';
import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/model/chat.dart';

abstract interface class IChatRepository {
  Future<List<FullChatEnity>> fetchChats({required String userId});

  Future<void> createChat({required CreatedChatEntity chat});

  Future<int> deleteChat({required int chatId});
}

class ChatRepository implements IChatRepository {
  const ChatRepository({required AppDatabase database}) : _database = database;

  final AppDatabase _database;

  @override
  Future<List<FullChatEnity>> fetchChats({required String userId}) async {
    final query =
        (_database.select(_database.chats).join([
            innerJoin(
              _database.messages,
              _database.messages.chatId.equalsExp(_database.chats.id),
            ),
            innerJoin(
              _database.users,
              Expression.or([
                (_database.users.uid.equalsExp(_database.chats.doctorId) &
                    _database.chats.userId.equals(userId)),
                (_database.users.uid.equalsExp(_database.chats.userId) &
                    _database.chats.doctorId.equals(userId)),
              ]),
            ),
          ]))
          ..where(
            (Expression.or([
              _database.chats.userId.equals(userId),
              _database.chats.doctorId.equals(userId),
            ])),
          )
          ..orderBy([
            OrderingTerm(
              expression: _database.messages.createdAt,
              mode: OrderingMode.desc,
            ),
          ])
          ..limit(1);

    final result = await query.get();

    final chats = result.map((row) {
      return FullChatEnity.fromCompanion(
        row.readTable(_database.chats),
        row.readTable(_database.messages),
        row.readTable(_database.users),
      );
    }).toList();

    return chats;
  }

  @override
  Future<void> createChat({required CreatedChatEntity chat}) async {
    await _database.into(_database.chats).insert(chat.toCompanion());
  }

  @override
  Future<int> deleteChat({required int chatId}) async {
    final result = await (_database.delete(
      _database.chats,
    )..where((chat) => chat.id.equals(chatId))).goAndReturn();

    if (result.isEmpty) {
      throw Exception('Chat not found');
    }

    final deletedChat = result[0].id;
    return deletedChat;
  }
}
