enum MessageRole {
  user,
  assistant,
  system;

  String get value {
    switch (this) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }
}

class ChatMessageEntity {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  ChatMessageEntity copyWith({
    String? id,
    MessageRole? role,
    String? content,
    DateTime? timestamp,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
