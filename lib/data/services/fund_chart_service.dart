import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:istreet/data/models/fund_chart.dart';

class FundChartService {
  static Future<FundChart> getFundChart(String fundName) async {
    final encoded = Uri.encodeComponent(fundName);
    final url =
        "https://istreet.in/istreet-api/trading_graph_api/?query=$encoded";

    print("📊 Fetching chart: $url");

    final res = await http.get(Uri.parse(url));

    if (res.statusCode != 200) {
      throw Exception("HTTP ERROR ${res.statusCode}");
    }

    final jsonData = jsonDecode(res.body);
    return FundChart.fromJson(jsonData);
  }
}
