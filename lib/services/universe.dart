import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:messenger_app/models/APIresponse.dart';
import 'package:messenger_app/services/authentification.dart'; 

class UniverseService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<Map<String, dynamic>>> getAllUniverseInfo() async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getAllUniverse: ${response.statusCode}');
    print('Response body getAllUniverse: ${response.body}');

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

  Future<ApiResponse> createUniverse(String name) async {
    final String? token = await AuthentificationService().getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    final data = {'name': name};

    final String jsonBody = jsonEncode(data);

    print('Request body: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/universes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status createUniverse: ${response.statusCode}');
    print('Response body createUniverse: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Universe created successfully');
      return ApiResponse.fromJson(jsonResponse);
    } else {
      return ApiResponse(success: false, message: 'Failed to create universe');
    }
  }

  Future<Map<String, dynamic>> getUniverseData(String id) async {
    final token = await AuthentificationService().getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status getOneUniverse: ${response.statusCode}');
    print('Response body getOneUniverse: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load one universe info: ${response.body}');
      return {};
    }
  }

  Future<ApiResponse> updateUniverse(String id, String name) async {
    final token = await AuthentificationService().getToken();
    final data = {'name': name};
    final jsonBody = jsonEncode(data);

    final response = await http.put(
      Uri.parse('$baseUrl/universes/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status updateUniverse: ${response.statusCode}');
    print('Response body updateUniverse: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Universe updated successfully');
      return ApiResponse.fromJson(jsonResponse);
    } else {
      print('Failed to update universe: ${response.body}');
      return ApiResponse(success: false, message: 'Failed to update universe');
    }
  }
}
