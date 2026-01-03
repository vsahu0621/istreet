import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:istreet/data/models/generic/community_detail_model.dart';
import 'package:istreet/data/services/auth_api.dart';
import 'package:istreet/data/services/auth_storage.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/providers/generic/community_provider.dart';

class CommunityService {
  static const String _url =
      'https://istreet.in/istreet-api/api_community_dashboard/';

  static Future<Map<String, dynamic>> fetchCommunityDashboard(
    Ref ref,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    if (response.statusCode == 401) {
      final refreshToken = await AuthStorage.getRefreshToken();
      if (refreshToken == null) return {};

      // 🔥 REFRESH TOKEN (FIXED)
      final newAccessToken = await AuthApi().refreshAccessToken(refreshToken);

      if (newAccessToken == null) {
        // refresh token expired → real logout
        await AuthStorage.clear();
        ref.read(authProvider.notifier).logout();
        return {};
      }

      // ✅ SAVE NEW TOKEN
      await AuthStorage.setToken(newAccessToken);

      // ✅ UPDATE PROVIDER STATE
      ref.read(authProvider.notifier).state = ref
          .read(authProvider)
          .copyWith(token: newAccessToken, isLoggedIn: true);

      // 🔁 RETRY ORIGINAL API
      final retry = await http.get(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
      );

      if (retry.statusCode == 200) {
        return jsonDecode(retry.body);
      }
    }

    return {};
  }
  //leave api

  // ✅ LEAVE COMMUNITY API (NO REF HERE)
  static Future<bool> leaveCommunity({required int communityId}) async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final url =
        'https://istreet.in/istreet-api/api_leave_community/$communityId/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  // ✅ JOIN COMMUNITY API
  static Future<bool> joinCommunity({required int communityId}) async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final url =
        'https://istreet.in/istreet-api/api_join_community/$communityId/join/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> createCommunity({
    required String name,
    required String description,
    required bool allowUserMessages,
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      return {"success": false, "error": "Not authenticated"};
    }

    final url = 'https://istreet.in/istreet-api/api_create_community/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "name": name,
        "description": description,
        "allow_user_messages": allowUserMessages ? "1" : "0",
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<bool?> toggleAllowUserMessages({
    required int communityId,
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) return null;

    final url =
        'https://istreet.in/istreet-api/api_toggle_community_settings/$communityId/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"setting": "allow_user_messages"}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['new_value']; // true / false
    }

    return null;
  }

  static Future<Map<String, dynamic>> fetchCommunityDetail(
    Ref ref,
    int communityId,
  ) async {
    final token = await AuthStorage.getToken();
    if (token == null) throw Exception("No token");

    final url =
        'https://istreet.in/istreet-api/api_community_detail/$communityId/';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load community detail");
  }

  // ================= SEND MESSAGE API =================
  static Future<Message?> sendCommunityMessage({
    required int communityId,
    required String message,
    required String type, // "text" | "reaction"
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) return null;

    final url = 'https://istreet.in/istreet-api/api_send_message/$communityId/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"message": message, "type": type}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Message.fromJson(json['data']);
    }

    return null;
  }
}
