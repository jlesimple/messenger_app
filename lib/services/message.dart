import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  final String apiUrl = 'https://mds.sprw.dev'; // Remplacez par l'URL de votre API

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Map<String, dynamic>>> getMessages(int conversationId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$apiUrl/conversations/$conversationId/messages'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> message) async {
    final token = await _getAuthToken();
    final response = await http.post(
      Uri.parse('$apiUrl/conversations/${message['conversation_id']}/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(message),
    );
    print('API response status: ${response.statusCode}');
    print('API response body: ${response.body}');
    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return {
        'success': true,
        'message': jsonResponse['message'],
        'answer': jsonResponse['answer'],
      };
    } else {
      return {'success': false, 'message': 'Failed to send message'};
    }
  }

  Future<Map<String, dynamic>> getLastCharacterMessage(int conversationId) async {
    final token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('$apiUrl/conversations/$conversationId/messages/last-character'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('No character messages found');
      }
    } else {
      throw Exception('Failed to load last character message');
    }
  }
}
