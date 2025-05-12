import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // Example GET request
  static Future<List<dynamic>> fetchDestinations() async {
    final response = await http.get(Uri.parse('[baseUrl]/posts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  // Example POST request
  static Future<bool> addDestination(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('[baseUrl]/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }
} 