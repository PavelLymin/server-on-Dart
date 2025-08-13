import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:medicine_server/src/common/constant/config.dart';
part 'database.g.dart';

class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chatId => integer().named('chat_id').references(Chats, #id)();
  TextColumn get senderId => text().named('sender_id')();
  TextColumn get content => text()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDate)();
  BoolColumn get isRead => boolean()();
}

class Chats extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get doctorId => text().named('doctor_id')();
  TextColumn get avatarUrl => text().named('avatar_url').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Messages, Chats])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static AppDatabase? instance;

  factory AppDatabase() => instance ?? AppDatabase._(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    final path = Config.databasePath;
    return NativeDatabase(File(path));
  }

  @override
  Future<void> close() {
    instance?.close();
    instance = null;
    return super.close();
  }
}
