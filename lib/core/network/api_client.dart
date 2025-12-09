import 'dart:convert';
import 'package:http/http.dart' as http;
import 'endpoints.dart';

class ApiClient {
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse(Endpoints.baseUrl + endpoint);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("GET Error: ${response.statusCode} → ${response.body}");
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse(Endpoints.baseUrl + endpoint);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("POST Error: ${response.statusCode} → ${response.body}");
    }
  }
}
