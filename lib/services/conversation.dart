import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:messenger_app/models/conversation.dart';
import 'package:messenger_app/services/authentification.dart';

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Conversation>> getUserConversations(int userId) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getUserConversations: ${response.statusCode}');
    print('Response body getUserConversations: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          json['image'] = 'https://mds.sprw.dev/image_data/${json['image']}';
          return Conversation.fromJson(json);
        }).toList();
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load conversations for user $userId: ${response.body}');
      return [];
    }
  }
}
