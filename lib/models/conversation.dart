import '../models/message.dart';

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
    final List<dynamic>? messagesJson = json['messages'];
    final List<Message> messages = messagesJson?.map((messageJson) => Message.fromJson(messageJson)).toList() ?? [];
    return Conversation(
      id: json['id'],
      userId: json['user_id'],
      characterId: json['character_id'],
      messages: messages,
    );
  }

  set image(String image) {}
}
