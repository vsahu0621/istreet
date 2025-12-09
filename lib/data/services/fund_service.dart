import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/fund_model.dart';

class FundService {
  static Future<List<FundModel>> fetchFundsByCategory(String category) async {
    final url =
        "https://istreet.in/istreet-api/api_funds_by_category/?category=$category";

    print("🔵 API CALL → $url");

    final response = await http.get(Uri.parse(url));

    print("🟡 STATUS → ${response.statusCode}");

    if (response.statusCode != 200) {
      print("❌ ERROR RESPONSE: ${response.body}");
      throw Exception("Failed: ${response.statusCode}");
    }

    // print raw body
    print("🟢 RAW RESPONSE: ${response.body}");

    final Map<String, dynamic> jsonData = jsonDecode(response.body);

    // print count
    print("📦 FUNDS COUNT: ${jsonData["funds"]?.length}");

    final List list = jsonData["funds"] ?? [];

    // print first item for debugging
    if (list.isNotEmpty) {
      print("🔍 FIRST ITEM: ${list.first}");
    } else {
      print("⚠️ EMPTY: No funds found for category → $category");
    }

    return list.map((e) => FundModel.fromJson(e)).toList();
  }
}
