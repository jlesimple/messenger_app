import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:messenger_app/models/conversation.dart';

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Conversation>> getUserConversations() async {
    final token = await getToken();
    final userId = await getId();

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
        final dynamic jsonData = jsonDecode(response.body);
        if (jsonData is List) {
          return jsonData.map((json) {
            json['image'] = 'https://mds.sprw.dev/image_data/${json['image']}';
            return Conversation.fromJson(json);
          }).toList();
        } else {
          print('Error: Response is not a List');
          return [];
        }
      } on FormatException catch (e) {
        print('Error parsing JSON: $e');
        return [];
      }
    } else {
      print('Failed to load conversations for user $userId: ${response.body}');
      return [];
    }
  }


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }
}
