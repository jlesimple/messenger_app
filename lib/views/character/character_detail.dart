import 'package:flutter/material.dart';
import 'package:messenger_app/models/character.dart';
import 'package:messenger_app/services/character.dart'; 

class CharacterDetailView extends StatefulWidget {
  final Character character;

  const CharacterDetailView({Key? key, required this.character}) : super(key: key);

  @override
  _CharacterDetailViewState createState() => _CharacterDetailViewState();
}

class _CharacterDetailViewState extends State<CharacterDetailView> {
  late Character _character;
  final CharacterService _characterService = CharacterService();

  @override
  void initState() {
    super.initState();
    _character = widget.character;
  }

  Future<void> _regenerateDescription() async {
    final regeneratedCharacter = await _characterService.regenerateCharacterDescription(_character.universeId, _character.name);
    if (regeneratedCharacter != null) {
      setState(() {
        _character = regeneratedCharacter;
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to regenerate description')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                _character.image,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 150.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Name: ${_character.name}',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Description: ${_character.description}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _regenerateDescription,
                child: Text('Regénérer la description'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
