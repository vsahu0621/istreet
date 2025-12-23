import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:istreet/data/models/sector_models.dart';

class SectorService {
  static const _base = "https://istreet.in/istreet-api";

  static Future<List<String>> fetchSectors() async {
    final res = await http.get(
      Uri.parse("$_base/sector_dropdown_api/"),
    );

    final data = json.decode(res.body);
    return List<String>.from(data['sectors']);
  }

  // ✅ USE GET (NOT POST)
  static Future<SectorPerformanceResponse> fetchSectorPerformance(
      String sector) async {
    final uri = Uri.parse(
      "$_base/get_select_sectors_api/?sector=${Uri.encodeComponent(sector)}",
    );

    final res = await http.get(uri);

    final data = json.decode(res.body);

    // 🧪 Debug
    print("Sector API response: $data");

    return SectorPerformanceResponse.fromJson(data);
  }
}
