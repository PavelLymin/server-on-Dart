import 'package:drift/drift.dart';
import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/model/message.dart';

abstract interface class IMessageRepository {
  Future<FullMessage> saveMessage({required CreatedMessage message});

  Future<List<FullMessage>> fetchMessages({required int chatId});

  Future<FullMessage> deleteMessage({
    required int chatId,
    required int messageId,
  });

  Future<FullMessage> updateMessage({required CreatedMessage message});
}

class MessageRepositoryImpl implements IMessageRepository {
  const MessageRepositoryImpl({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Future<FullMessage> saveMessage({required CreatedMessage message}) async {
    final result = await _database
        .into(_database.messages)
        .insertReturning(message.toCompanion());

    final savedMessage = FullMessage.fromCompanion(result);

    return savedMessage;
  }

  @override
  Future<List<FullMessage>> fetchMessages({required int chatId}) async {
    final result =
        await (_database.select(_database.messages)
              ..where((message) => message.chatId.equals(chatId))
              ..orderBy([
                (message) => OrderingTerm(
                  expression: message.createdAt,
                  mode: OrderingMode.asc,
                ),
              ]))
            .get();

    final messages = result
        .map((row) => FullMessage.fromCompanion(row))
        .toList();

    return messages;
  }

  @override
  Future<FullMessage> deleteMessage({
    required int chatId,
    required int messageId,
  }) async {
    final result =
        await (_database.delete(_database.messages)..where(
              (message) =>
                  message.id.equals(messageId) & message.chatId.equals(chatId),
            ))
            .goAndReturn();

    if (result.isEmpty) {
      throw Exception('Message not found');
    }

    final deletedMessage = FullMessage.fromCompanion(result[0]);
    return deletedMessage;
  }

  @override
  Future<FullMessage> updateMessage({required CreatedMessage message}) async {
    final result =
        await (_database.update(_database.messages)..where(
              (message) =>
                  message.id.equalsExp(message.id) &
                  message.chatId.equalsExp(message.chatId),
            ))
            .writeReturning(message.toCompanion());

    if (result.isEmpty) {
      throw Exception('Message not found');
    }

    final updatedMessage = FullMessage.fromCompanion(result[0]);

    return updatedMessage;
  }
}
