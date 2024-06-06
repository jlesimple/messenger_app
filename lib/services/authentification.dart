import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/APIresponse.dart';

class AuthentificationService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<ApiResponse> login(String username, String password) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    final String jsonBody = jsonEncode(data);

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
        final tokenParts = jsonResponse['token'].split('.');
        final payload =
            json.decode(utf8.decode(base64Url.decode(tokenParts[1].padRight(
          tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
          '=',
        ))));
        final data = jsonDecode(payload['data']);
        await saveId(data['id']);
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to login');
    }
  }

  Future<ApiResponse> register(String username, String password, String email,
      String firstname, String lastname) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    };

    final String jsonBody = jsonEncode(data);

    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
        final tokenParts = jsonResponse['token'].split('.');
        json.decode(utf8.decode(base64Url.decode(tokenParts[1].padRight(
          tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
          '=',
        ))));
      }
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to register');
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id.toString());
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('token');
  }

  getUserInfo() {}
}
