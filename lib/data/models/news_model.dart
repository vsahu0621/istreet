class NewsItem {
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String publishedAt;

  NewsItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.publishedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? "",
      description: json['description'] ?? json['summary'] ?? "",
      imageUrl: json['image_url'] ?? json['image'] ?? "",
      url: json['url'] ?? "",
      publishedAt: json['published_at'] ?? "",
    );
  }
}
