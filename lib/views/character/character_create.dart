import 'package:flutter/material.dart';
import 'package:messenger_app/models/character.dart'; // Assurez-vous d'importer la classe Character
import 'package:messenger_app/services/character.dart'; // Assurez-vous d'importer le service CharacterService

class CharacterCreateView extends StatefulWidget {
  final String universeId;

  CharacterCreateView({required this.universeId});

  @override
  _CharacterCreateViewState createState() => _CharacterCreateViewState();
}

class _CharacterCreateViewState extends State<CharacterCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _characterNameController = TextEditingController();
  CharacterService _characterService = CharacterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un personnage'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _characterNameController,
                decoration: InputDecoration(labelText: 'Nom du personnage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir le nom du personnage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createCharacter();
                  }
                },
                child: Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createCharacter() async {
    String name = _characterNameController.text.trim();
    if (name.isNotEmpty) {
      Character? createdCharacter = await _characterService.createCharacter(widget.universeId, name);
      if (createdCharacter != null) {
        // Afficher un message de succès ou naviguer vers une autre vue
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Personnage créé avec succès'),
        ));
        // Vous pouvez naviguer vers une autre vue ici si nécessaire
      } else {
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la création du personnage'),
        ));
      }
    }
  }

  @override
  void dispose() {
    _characterNameController.dispose();
    super.dispose();
  }
}
