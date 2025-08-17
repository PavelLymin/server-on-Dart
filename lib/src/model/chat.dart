import 'package:drift/drift.dart';
import 'package:medicine_server/src/data/database/database.dart';
import 'package:medicine_server/src/model/message.dart';
import 'package:medicine_server/src/model/user.dart';

sealed class ChatEntity {
  const ChatEntity();

  const factory ChatEntity.created({
    required String userId,
    required String doctorId,
  }) = CreatedChatEntity;
}

class CreatedChatEntity extends ChatEntity {
  const CreatedChatEntity({required this.userId, required this.doctorId});

  final String userId;
  final String doctorId;

  factory CreatedChatEntity.fromJson(Map<String, dynamic> json) =>
      CreatedChatEntity(
        userId: json['user_id'] as String,
        doctorId: json['doctor_id'] as String,
      );

  Map<String, dynamic> toJson() => {'user_id': userId, 'doctor_id': doctorId};

  factory CreatedChatEntity.fromCompanion(Chat companion) =>
      CreatedChatEntity(userId: companion.userId, doctorId: companion.doctorId);

  ChatsCompanion toCompanion() =>
      ChatsCompanion(userId: Value(userId), doctorId: Value(doctorId));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedChatEntity &&
        other.userId == userId &&
        other.doctorId == doctorId;
  }

  @override
  int get hashCode => Object.hash(userId, doctorId);

  @override
  String toString() {
    return 'CreatedChat(userId: $userId, doctorId: $doctorId)';
  }
}

class FullChatEnity extends ChatEntity {
  const FullChatEnity({
    required this.id,
    required this.interlocutor,
    required this.lastMessage,
    required this.createdAt,
  });

  final int id;
  final UserEntity interlocutor;
  final FullMessage lastMessage;
  final DateTime createdAt;

  factory FullChatEnity.fromJson(Map<String, dynamic> json) => FullChatEnity(
    id: json['id'] as int,
    interlocutor: UserEntity.fromJson(
      json['interlocutor'] as Map<String, dynamic>,
    ),
    lastMessage: FullMessage.fromJson(
      json['last_message'] as Map<String, dynamic>,
    ),
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'interlocutor': interlocutor.toJson(),
    'last_message': lastMessage.toJson(),
    'created_at': createdAt.toIso8601String(),
  };

  factory FullChatEnity.fromCompanion(
    Chat chatCompanion,
    Message messageCompanion,
    User interlocutor,
  ) => FullChatEnity(
    id: chatCompanion.id,
    createdAt: chatCompanion.createdAt,
    lastMessage: FullMessage.fromCompanion(messageCompanion),
    interlocutor: UserEntity.fromCompanion(interlocutor),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullChatEnity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FullChat(id: $id, interlocutor: $interlocutor, createdAt: $createdAt, lastMessage: $lastMessage)';
  }
}
