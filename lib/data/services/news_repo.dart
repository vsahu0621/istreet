import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsRepo {
  Future<List<NewsItem>> fetchNews(int filterId) async {
    final url = Uri.parse("https://istreet.in/news/api/?filter=$filterId");

    print("➡ Fetching News: $url");

    final response = await http.get(url);

    print("STATUS: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Pretty-print raw response
      print("RAW RESPONSE:\n${response.body}");

      final data = jsonDecode(response.body);

      print("NEWS ARRAY COUNT: ${data["news"]?.length ?? 0}");

      List list = data["news"] ?? [];

      // Convert JSON to model
      List<NewsItem> newsList = list.map((e) => NewsItem.fromJson(e)).toList();

      // Print each news item for debugging
      for (var item in newsList) {
        print("------------------------------");
        print("TITLE      : ${item.title}");
        print("IMAGE URL  : ${item.imageUrl}");
        print("DATE       : ${item.publishedAt}");
      }
      print("------------------------------");

      return newsList;
    } else {
      print("❌ ERROR: ${response.statusCode}");
      throw Exception("Error: ${response.statusCode}");
    }
  }
}
