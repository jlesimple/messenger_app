import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversation.dart';
import 'package:messenger_app/models/message.dart';


class ConversationMessagerieScreen extends StatefulWidget {
  final Conversation conversation;

  ConversationMessagerieScreen({required this.conversation});

  @override
  _ConversationMessagerieScreenState createState() =>
      _ConversationMessagerieScreenState();
}

class _ConversationMessagerieScreenState
    extends State<ConversationMessagerieScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.conversation.messages;
  }

  void _sendMessage(String messageContent) {
    // Create a new message object
    final newMessage = Message(
      id: _messages.length + 1,
      content: messageContent,
      isSentByHuman: true, // Assuming the user sends the message
      conversationId: widget.conversation.id,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation ${widget.conversation.id}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(
                      '${message.isSentByHuman ? 'You' : 'Bot'} - ${message.createdAt}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
