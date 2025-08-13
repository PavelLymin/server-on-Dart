import 'package:drift/drift.dart';
import 'package:medicine_server/src/data/database/database.dart';

abstract class ChatEntity {
  const ChatEntity({
    required this.userId,
    required this.doctorId,
    this.avatarUrl,
  });

  final String userId;
  final String doctorId;
  final String? avatarUrl;

  ChatsCompanion toCompanion();

  Map<String, dynamic> toJson();
}

class CreatedChat extends ChatEntity {
  const CreatedChat({
    required super.userId,
    required super.doctorId,
    super.avatarUrl,
  });

  factory CreatedChat.fromJson(Map<String, dynamic> json) {
    return CreatedChat(
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'doctor_id': doctorId,
    'avatar_url': avatarUrl,
  };

  @override
  ChatsCompanion toCompanion() {
    return ChatsCompanion(
      userId: Value(userId),
      doctorId: Value(doctorId),
      avatarUrl: Value(avatarUrl),
    );
  }

  factory CreatedChat.fromCompanion(Chat companion) => CreatedChat(
    userId: companion.userId,
    doctorId: companion.doctorId,
    avatarUrl: companion.avatarUrl,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CreatedChat &&
        other.userId == userId &&
        other.doctorId == doctorId &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode => Object.hash(userId, doctorId, avatarUrl);

  @override
  String toString() {
    return 'CreatedChat(userId: $userId, doctorId: $doctorId, avatarUrl: $avatarUrl)';
  }
}

class FullChat extends ChatEntity {
  const FullChat({
    required super.userId,
    required super.doctorId,
    super.avatarUrl,
    required this.id,
    required this.createdAt,
  });

  final int id;
  final DateTime createdAt;

  factory FullChat.fromJson(Map<String, dynamic> json) {
    return FullChat(
      userId: json['user_id'] as String,
      doctorId: json['doctor_id'] as String,
      avatarUrl: json['avatar_url'] as String?,
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'doctor_id': doctorId,
    'avatar_url': avatarUrl,
    'id': id,
    'created_at': createdAt.toIso8601String(),
  };

  @override
  ChatsCompanion toCompanion() {
    return ChatsCompanion(
      id: Value(id),
      userId: Value(userId),
      doctorId: Value(doctorId),
      avatarUrl: Value(avatarUrl),
      createdAt: Value(createdAt),
    );
  }

  factory FullChat.fromCompanion(Chat companion) => FullChat(
    userId: companion.userId,
    doctorId: companion.doctorId,
    avatarUrl: companion.avatarUrl,
    id: companion.id,
    createdAt: companion.createdAt,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FullChat &&
        other.id == id &&
        other.userId == userId &&
        other.doctorId == doctorId &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, userId, doctorId, avatarUrl, createdAt);

  @override
  String toString() {
    return 'FullChat(id: $id, userId: $userId, doctorId: $doctorId, avatarUrl: $avatarUrl, createdAt: $createdAt)';
  }
}
