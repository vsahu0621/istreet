import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityService {
  static const String _url =
      'https://istreet.in/istreet-api/api_community_dashboard/';

  static Future<Map<String, dynamic>> fetchCommunityDashboard(
    String token,
  ) async {
    try {
      print("➡️ API HIT: $_url");
      print("🔐 TOKEN (JWT): $token");

      final response = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $token', // ✅ FIXED
          'Content-Type': 'application/json',
        },
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("API Error ${response.statusCode}: ${response.body}");
      }
    } catch (e, s) {
      print("❌ SERVICE ERROR: $e");
      print("📌 STACKTRACE: $s");
      rethrow;
    }
  }
}
