import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:istreet/data/models/auth_response.dart';

class AuthApi {
  static const String _baseUrl = 'https://istreet.in/istreet-api';

  // ---------------- LOGIN ----------------
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api_user_login/');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthResponse.fromJson(data);
  }

  // ---------------- REGISTER ----------------
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/api_user_register/');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthResponse.fromJson(data);
  }

  // =====================================================
  // 🔥 ADD THIS METHOD (TOKEN REFRESH) ← यही पूछ रहे थे
  // =====================================================
  Future<String?> refreshAccessToken(String refreshToken) async {
    final uri = Uri.parse('$_baseUrl/api/token/refresh/');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refresh': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access']; // ✅ NEW ACCESS TOKEN
    }

    return null; // refresh expired / invalid
  }
}
