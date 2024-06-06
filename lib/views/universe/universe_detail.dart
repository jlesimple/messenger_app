import 'package:flutter/material.dart';
import 'package:messenger_app/models/universe.dart';
import 'package:messenger_app/views/character/character.dart'; // Assurez-vous d'importer la vue CharacterListPage

class UniverseDetailView extends StatelessWidget {
  final Universe universe;

  const UniverseDetailView({Key? key, required this.universe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Affichage des détails pour : ${universe.name}');
    print('Description : ${universe.description}');

    return Scaffold(
      appBar: AppBar(
        title: Text(universe.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterListPage(universeId: universe.id),
                ),
              );
            },
            icon: Icon(Icons.group), // Vous pouvez changer l'icône selon vos préférences
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://mds.sprw.dev/image_data/${universe.image}',
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 75.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                universe.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                universe.description.isNotEmpty ? universe.description : 'No description available',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
