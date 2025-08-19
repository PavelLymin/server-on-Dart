import 'package:drift/drift.dart';
import 'package:medicine_server/src/data/database/database.dart';

abstract class MessageEntity {
  const MessageEntity({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });

  final int chatId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  MessagesCompanion toCompanion();

  Map<String, dynamic> toJson();
}

class CreatedMessage extends MessageEntity {
  const CreatedMessage({
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.createdAt,
    super.isRead = false,
  });

  factory CreatedMessage.fromJson(Map<String, dynamic> json) {
    return CreatedMessage(
      chatId: json['chat_id'] as int,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'chat_id': chatId,
    'sender_id': senderId,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    'is_read': isRead,
  };

  factory CreatedMessage.fromCompanion(Message companion) => CreatedMessage(
    chatId: companion.chatId,
    senderId: companion.senderId,
    content: companion.content,
    createdAt: companion.createdAt,
    isRead: companion.isRead,
  );

  @override
  MessagesCompanion toCompanion() {
    return MessagesCompanion(
      chatId: Value(chatId),
      senderId: Value(senderId),
      content: Value(content),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedMessage &&
        other.chatId == chatId &&
        other.senderId == senderId &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode => Object.hash(chatId, senderId, content, createdAt, isRead);

  @override
  String toString() {
    return 'CreatedMessage(chatId: $chatId, senderId: $senderId, content: $content, createdAt: $createdAt, isRead: $isRead)';
  }
}

class FullMessage extends MessageEntity {
  const FullMessage({
    required this.id,
    required super.chatId,
    required super.senderId,
    required super.content,
    required super.createdAt,
    super.isRead = false,
  });

  final int id;

  factory FullMessage.fromJson(Map<String, dynamic> json) {
    return FullMessage(
      id: json['id'] as int,
      chatId: json['chat_id'] as int,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isRead: json['is_read'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'chat_id': chatId,
    'sender_id': senderId,
    'content': content,
    'created_at': createdAt.toIso8601String(),
    'is_read': isRead,
  };

  factory FullMessage.fromCompanion(Message companion) => FullMessage(
    id: companion.id,
    chatId: companion.chatId,
    senderId: companion.senderId,
    content: companion.content,
    createdAt: companion.createdAt,
    isRead: companion.isRead,
  );

  @override
  MessagesCompanion toCompanion() {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      senderId: Value(senderId),
      content: Value(content),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullMessage &&
        other.id == id &&
        other.chatId == chatId &&
        other.senderId == senderId &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.isRead == isRead;
  }

  @override
  int get hashCode =>
      Object.hash(id, chatId, senderId, content, createdAt, isRead);

  @override
  String toString() {
    return 'FullMessage(id: $id, chatId: $chatId, senderId: $senderId, content: $content, createdAt: $createdAt, isRead: $isRead)';
  }
}
