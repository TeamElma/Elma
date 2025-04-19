class ChatContact {
  final String id;
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? avatarUrl;

  ChatContact({
    required this.id,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.avatarUrl,
  });

  ChatContact copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
  }) {
    return ChatContact(
      id: id,
      name: name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      avatarUrl: avatarUrl,
    );
  }
}
