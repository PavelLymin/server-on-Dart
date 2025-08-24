enum PrecentState {
  startTyping('start_typing'),
  stopTyping('stop_typing');

  const PrecentState(this.value);
  final String value;

  factory PrecentState.fromString(String? value) {
    return PrecentState.values.firstWhere(
      (type) => type.value == value?.trim().toLowerCase(),
      orElse: () => throw ArgumentError('Unknown typing state: $value'),
    );
  }
}

sealed class PrecentRequestHandler {
  const PrecentRequestHandler({required this.state});
  final PrecentState state;

  factory PrecentRequestHandler.fromJson(Map<String, dynamic> json) {
    final type = PrecentState.fromString(json['type'] as String);

    switch (type) {
      case PrecentState.startTyping:
        return StartTyping.fromJson(json);
      case PrecentState.stopTyping:
        return StopTyping.fromJson(json);
    }
  }
}

class StartTyping extends PrecentRequestHandler {
  const StartTyping({
    super.state = PrecentState.startTyping,
    required this.userId,
    required this.chatId,
  });

  final String userId;
  final int chatId;

  factory StartTyping.fromJson(Map<String, dynamic> json) {
    return StartTyping(
      userId: json['user_id'] as String,
      chatId: json['chat_id'] as int,
    );
  }
}

class StopTyping extends PrecentRequestHandler {
  const StopTyping({
    super.state = PrecentState.stopTyping,
    required this.userId,
    required this.chatId,
  });

  final String userId;
  final int chatId;

  factory StopTyping.fromJson(Map<String, dynamic> json) {
    return StopTyping(
      userId: json['user_id'] as String,
      chatId: json['chat_id'] as int,
    );
  }
}
