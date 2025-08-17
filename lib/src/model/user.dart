import '../data/database/database.dart';

class UserEntity {
  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.photoURL,
    required this.email,
  });

  final String uid;
  final String displayName;
  final String? photoURL;
  final String email;

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    uid: json['uid'] as String,
    displayName: json['display_name'] as String,
    photoURL: json['photo_url'] as String?,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'display_name': displayName,
      'photo_url': photoURL,
      'email': email,
    };
  }

  factory UserEntity.fromCompanion(User userCompanion) => UserEntity(
    uid: userCompanion.uid,
    displayName: userCompanion.displayName,
    photoURL: userCompanion.photoURL,
    email: userCompanion.email,
  );

  @override
  String toString() =>
      'UserEntity('
      'uid: $uid, '
      'name: $displayName, '
      'photoURL: $photoURL, '
      'email: $email)';

  @override
  bool operator ==(final Object other) =>
      other is UserEntity && uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
