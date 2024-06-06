import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:messenger_app/services/authentification.dart'; 
import 'package:messenger_app/models/character.dart'; // Assurez-vous d'importer la classe Character

class CharacterService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Character>> getCharactersByUniverseId(String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getCharactersByUniverseId: ${response.statusCode}');
    print('Response body getCharactersByUniverseId: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((characterJson) {
          characterJson['image'] = 'https://mds.sprw.dev/image_data/${characterJson['image']}';
          return Character.fromJson(characterJson);
        }).toList();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load characters for universe $universeId: ${response.body}');
      return [];
    }
  }

  Future<Character?> createCharacter(String universeId, String name) async {
    final token = await AuthentificationService().getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    print('Response status createCharacter: ${response.statusCode}');
    print('Response body createCharacter: ${response.body}');

    if (response.statusCode == 201) {
      try {
        final characterJson = jsonDecode(response.body);
        characterJson['image'] = 'https://mds.sprw.dev/image_data/${characterJson['image']}';
        return Character.fromJson(characterJson);
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return null;
      }
    } else {
      print('Failed to create character for universe $universeId: ${response.body}');
      return null;
    }
  }
}
