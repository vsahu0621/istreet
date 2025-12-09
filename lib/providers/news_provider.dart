import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/news_repo.dart';
import '../data/models/news_model.dart';

/// 1️⃣ Selected filter (Today / Yesterday / 7 Days / 30 Days)
final newsFilterProvider = StateProvider<int>((ref) => 1);

/// 2️⃣ Fetch news based on selected filter
final newsProvider = FutureProvider<List<NewsItem>>((ref) async {
  final filterId = ref.watch(newsFilterProvider);
  return NewsRepo().fetchNews(filterId);
});
