import 'package:flutter/material.dart';
import 'package:messenger_app/models/conversation.dart';
import 'package:messenger_app/models/character.dart';
import 'package:messenger_app/services/conversation.dart';
import 'package:messenger_app/services/character.dart';

class ConversationListView extends StatefulWidget {
  @override
  _ConversationListViewState createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {
  final ConversationService _conversationService = ConversationService();
  final CharacterService _characterService = CharacterService();
  late List<Conversation> _conversations;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final List<Map<String, dynamic>> conversationsData = await _conversationService.getAllConversation();
    setState(() {
      _conversations = conversationsData.map((data) => Conversation.fromJson(data)).toList();
    });
  }

  Future<String> _getCharacterName(int characterId) async {
    final String characterIdString = characterId.toString(); // Convert to String
    final Character? character = await _characterService.getCharacterById(characterIdString);
    return character?.name ?? 'Unknown Character';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
      ),
      body: _conversations != null
          ? ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return ListTile(
                  title: FutureBuilder<String>(
                    future: _getCharacterName(conversation.characterId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(snapshot.data ?? 'Unknown Character');
                      }
                    },
                  ),
                  // You can add more details of the conversation here
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
