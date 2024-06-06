import 'package:flutter/material.dart';
import 'package:messenger_app/models/universe.dart';
import 'package:messenger_app/models/character.dart';
import 'package:messenger_app/models/conversation.dart';
import 'package:messenger_app/services/universe.dart';
import 'package:messenger_app/services/character.dart';
import 'package:messenger_app/services/conversation.dart';

class ConversationSelectionScreen extends StatefulWidget {
  @override
  _ConversationSelectionScreenState createState() => _ConversationSelectionScreenState();
}

class _ConversationSelectionScreenState extends State<ConversationSelectionScreen> {
  final PageController _pageController = PageController();
  Character? _selectedCharacter;
  Future<List<Universe>>? _universesFuture;
  Future<List<Character>>? _charactersFuture;
  Future<List<Conversation>>? _conversationsFuture;

  @override
  void initState() {
    super.initState();
    _loadAllUniverse();
  }

  Future<void> _loadAllUniverse() async {
    _universesFuture = UniverseService().getAllUniverseInfo().then(
      (data) => data.map((json) => Universe.fromJson(json)).toList(),
    );
  }

  Future<void> _loadCharactersForUniverse(String universeId) async {
    _charactersFuture = CharacterService().getCharactersByUniverseId(universeId);
  }

  Future<void> _loadAllConversation(int characterId) async {
    _conversationsFuture = ConversationService().getUserConversations(characterId);
  }

  void _onUniverseSelected(Universe universe) {
    setState(() {
      _loadCharactersForUniverse(universe.id);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  void _onCharacterSelected(Character character) {
    setState(() {
      _selectedCharacter = character;
      _loadAllConversation(int.parse(character.id));
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Conversation')),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildUniverseSelection(),
          _buildCharacterSelection(),
          _buildConversationList(),
        ],
      ),
    );
  }

  Widget _buildUniverseSelection() {
    return FutureBuilder<List<Universe>>(
      future: _universesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading universes'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No universes found'));
        } else {
          final universes = snapshot.data!;
          return ListView.builder(
            itemCount: universes.length,
            itemBuilder: (context, index) {
              final universe = universes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://mds.sprw.dev/image_data/${universe.image}'),
                ),
                title: Text(universe.name),
                onTap: () => _onUniverseSelected(universe),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildCharacterSelection() {
    return FutureBuilder<List<Character>>(
      future: _charactersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading characters'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No characters found'));
        } else {
          final characters = snapshot.data!;
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(character.image),
                ),
                title: Text(character.name),
                onTap: () => _onCharacterSelected(character),
              );
            },
          );
        }
      },
    );
  }


  Widget _buildConversationList() {
    return FutureBuilder<List<Conversation>>(
      future: _conversationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading conversations'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No conversations found'));
        } else {
          final conversations = snapshot.data!;
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                title: Text('Conversation ${conversation.id}'),
                subtitle: Text(conversation.messages.isNotEmpty
                    ? conversation.messages.last.content
                    : 'No messages'),
                onTap: () {
                },
              );
            },
          );
        }
      },
    );
  }
}
