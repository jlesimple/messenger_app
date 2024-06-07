import 'package:flutter/material.dart';
import 'package:messenger_app/services/character.dart';
import 'package:messenger_app/services/conversation.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationService _apiConversationService = ConversationService();
  final CharacterService _apiCharactereService = CharacterService();
  List<Map<String, dynamic>> _allConversation = [];
  String? _message;

  String? selectedUniverse;
  String? selectedCharacter;
  List<Map<String, dynamic>> universes = [];
  List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    _loadAllConversation();
    _loadAllUniverse();
  }

  Future<void> _loadAllConversation() async {
    final allConversation =
        await _apiConversationService.getAllConversation();
    setState(() {
      _allConversation = allConversation;
    });
  }

  Future<void> _loadAllUniverse() async {
    final allUniverse = await _apiConversationService.getAllUniverse();
    setState(() {
      universes = allUniverse;
    });
  }

  Future<void> _loadCharactersForUniverse(String universeId) async {
    final charactersInUniverse =
        await _apiConversationService.getCharactersByUniverse(universeId);
    setState(() {
      characters = charactersInUniverse;
      selectedCharacter = null;
    });
  }

  void _createConversation() async {
    final selectedCharacter = this.selectedCharacter;

    final response =
        await _apiConversationService.createConversation(selectedCharacter!);

    if (response.success) {
      _loadAllConversation();
    }
  }

  Future<Map<String, dynamic>> _getCharacterById(String charactereId) async {
    return await _apiCharactereService.getCharacters(charactereId);
  }

  void _onConversationDismissed(Map<String, dynamic> conversation) async {
    final response = await _apiConversationService.deleteConversation(
      conversation['id'].toString(),
    );

    if (response.success) {
      _loadAllConversation();
    } else {
      setState(() {
        _message = response.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation List'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllConversation,
        child: ListView.builder(
          itemCount: _allConversation.length,
          itemBuilder: (context, index) {
            final conversation = _allConversation[index];
            return Dismissible(
              key: Key(conversation['id'].toString()),
              onDismissed: (direction) {
                _onConversationDismissed(conversation);
              },
              background: Stack(
                children: <Widget>[
                  Container(color: Colors.red),
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              child: FutureBuilder<Map<String, dynamic>>(
                future: _getCharacterById(
                    conversation['character_id'].toString()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  } else if (snapshot.hasError) {
                    return const ListTile(
                      title: Text('Error loading character'),
                    );
                  } else {
                    final character = snapshot.data ?? {};
                    return ListTile(
                      leading: character['image'] != null
                          ? Image.network(
                              'https://mds.sprw.dev/image_data/${character['image']}',
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            )
                          : const Icon(Icons.person),
                      title: Text(character['name'] ?? 'Unknown'),
                      onTap: () =>
                          _onConversationTap(conversation), // Ajout de cette ligne
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Créer une conversation'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: selectedUniverse,
                          hint: const Text('Sélectionnez un univers'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUniverse = newValue;
                            });
                            if (newValue != null) {
                              _loadCharactersForUniverse(newValue);
                            }
                          },
                          items: universes
                              .map((e) => DropdownMenuItem<String>(
                                    value: e['id'].toString(),
                                    child: Text(e['name']),
                                  ))
                              .toList(),
                        ),
                        if (selectedUniverse != null)
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: _apiConversationService
                                .getCharactersByUniverse(selectedUniverse!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Erreur de chargement');
                              } else {
                                final characters = snapshot.data ?? [];
                                return DropdownButton<String>(
                                  value: selectedCharacter,
                                  hint:
                                      const Text('Sélectionnez un personnage'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCharacter = newValue;
                                    });
                                  },
                                  items: characters
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e['id'].toString(),
                                            child: Text(e['name']),
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          _createConversation();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Créer'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  // Ajout de la méthode _onConversationTap
  void _onConversationTap(Map<String, dynamic> conversation) {
    // Implémentez le code pour gérer le tap sur la conversation ici
  }
}
