import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:messenger_app/models/APIresponse.dart';
import 'package:messenger_app/services/authentification.dart';

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllConversation() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllConversation: ${response.statusCode}');
    print('Response body getAllConversation: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all conversation: ${response.body}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllUniverse() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status getAllUniverse: ${response.statusCode}');
    //print('Response body getAllUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all universe: ${response.body}');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCharactersByUniverse(
      String universeId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$universeId/characters'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status getCharactersByUniverse: ${response.statusCode}');
    //print('Response body getCharactersByUniverse: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all user info: ${response.body}');
      return [];
    }
  }

  Future<ApiResponse> createConversation(String charactereID) async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    final String? userId = await AuthentificationService().getId();

    final data = {'character_id': charactereID, 'user_id': userId};
    final String jsonBody = jsonEncode(data);

    print('Request body: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    //print('Response status createConversation: ${response.statusCode}');
    //print('Response body createConversation: ${response.body}');

    if (response.statusCode == 201) {
      return ApiResponse(success: true, message: 'Conversation created');
    } else {
      return ApiResponse(
          success: false, message: 'Failed to create conversation');
    }
  }

  //delete conversation
  Future<ApiResponse> deleteConversation(String conversationId) async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/conversations/$conversationId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status deleteConversation: ${response.statusCode}');
    //print('Response body deleteConversation: ${response.body}');

    if (response.statusCode == 200) {
      return ApiResponse(success: true, message: 'Conversation deleted');
    } else {
      return ApiResponse(
          success: false, message: 'Failed to delete conversation');
    }
  }

    Future<List<Map<String, dynamic>>> getAllUniverseInfo() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load all universe info: ${response.body}');
      return [];
    }
  }

  Future<Map<String, dynamic>> getCharacters(String charactereID) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/characters/$charactereID'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('Response status getCharacter: ${response.statusCode}');
    //print('Response body getCharacter: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return {};
      }
    } else {
      print('Failed to load character info: ${response.body}');
      return {};
    }
  }

}
