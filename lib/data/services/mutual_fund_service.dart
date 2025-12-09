import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:istreet/data/models/mutual_fund.dart';

class MutualFundService {
  static Future<List<MutualFund>> searchFundHouse(String query) async {
    final url =
        "https://istreet.in/istreet-api/api_search_fund_house/?q=$query";

    print("🟦===============================");
    print("🔵 SEARCH CALLED WITH QUERY: '$query'");
    print("🔵 API URL: $url");
    print("🟦===============================");

    try {
      final response = await http.get(Uri.parse(url));

      print("🟣 STATUS CODE: ${response.statusCode}");

      if (response.body.isEmpty) {
        print("🔴 RESPONSE BODY EMPTY!!!");
      }

      print("🟠 RAW RESPONSE:");
      print(response.body);

      if (response.statusCode != 200) {
        print("❌ API ERROR: ${response.statusCode}");
        throw Exception("HTTP ERROR ${response.statusCode}");
      }

      final jsonData = jsonDecode(response.body);

      print("🟢 PARSED JSON KEYS: ${jsonData.keys}");

      if (!jsonData.containsKey("results")) {
        print("❌ 'results' key NOT FOUND in API!");
        return [];
      }

      final List list = jsonData["results"] ?? [];

      print("🟡 TOTAL ITEMS RECEIVED: ${list.length}");

      for (var e in list) {
        print("➡ FUND ITEM: $e\n");
      }

      return list.map((e) => MutualFund.fromJson(e)).toList();
    } catch (e) {
      print("❌ EXCEPTION: $e");
      return [];
    }
  }
}
