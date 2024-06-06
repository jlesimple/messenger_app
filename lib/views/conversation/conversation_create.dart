import 'package:flutter/material.dart';
import 'package:messenger_app/models/character.dart';
import 'package:messenger_app/models/conversation.dart';

class ConversationCreateScreen extends StatefulWidget {
  final Character selectedCharacter;
  final Function(Conversation) onConversationCreated;

  ConversationCreateScreen({
    required this.selectedCharacter,
    required this.onConversationCreated,
  });

  @override
  _ConversationCreateScreenState createState() =>
      _ConversationCreateScreenState();
}

class _ConversationCreateScreenState extends State<ConversationCreateScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createConversation() async {
    setState(() {
      _isLoading = true;
    });

    // Call your conversation service to create a new conversation
    // Here, you can use widget.selectedCharacter to access the selected character

    // Simulate creating a conversation with a delay
    await Future.delayed(Duration(seconds: 2));

    // Once the conversation is created, construct a Conversation object
    final newConversation = Conversation(
      id: 1, // Replace with the actual ID of the created conversation
      userId: 1, // Replace with the actual user ID
      characterId: int.parse(widget.selectedCharacter.id),
      messages: [], // Initially, the conversation has no messages
    );

    // Notify the parent widget about the created conversation
    widget.onConversationCreated(newConversation);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context); // Close the create conversation screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Conversation'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Start a conversation with ${widget.selectedCharacter.name}',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _createConversation,
                    child: Text('Create Conversation'),
                  ),
                ],
              ),
            ),
    );
  }
}
