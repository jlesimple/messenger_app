import 'package:flutter/material.dart';
import 'package:messenger_app/models/character.dart'; 
import 'package:messenger_app/services/character.dart'; 
import 'package:messenger_app/views/character/character_detail.dart'; // Assurez-vous d'importer la vue CharacterDetailView
import 'package:messenger_app/views/character/character_create.dart'; // Assurez-vous d'importer la vue CharacterCreateView

class CharacterListPage extends StatefulWidget {
  final String universeId;

  CharacterListPage({required this.universeId});

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late Future<List<Character>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = CharacterService().getCharactersByUniverseId(widget.universeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterCreateView(universeId: widget.universeId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _charactersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No characters found'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Character character = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(character.image),
                  ),
                  title: Text(character.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterDetailView(character: character),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
