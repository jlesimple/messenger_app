class Conversation {
  final int id;
  final int userId;
  final int characterId;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.userId,
    required this.characterId,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final List<dynamic> messagesJson = json['item'];
    final List<Message> messages =
        messagesJson.map((messageJson) => Message.fromJson(messageJson)).toList();
    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      characterId: json['character_id'],
      messages: messages,
    );
  }
}

class Message {
  final int id;
  final String content;
  final bool isSentByHuman;
  final int conversationId;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.isSentByHuman,
    required this.conversationId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      isSentByHuman: json['is_sent_by_human'],
      conversationId: json['conversation_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
