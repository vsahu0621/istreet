class SupportResistanceLevel {
  final String level;
  final double classic;
  final double fibonacci;
  final double camarilla;
  final String scrapedAt; // keep as String but allow null input

  SupportResistanceLevel({
    required this.level,
    required this.classic,
    required this.fibonacci,
    required this.camarilla,
    required this.scrapedAt,
  });

  factory SupportResistanceLevel.fromJson(Map<String, dynamic> json) {
    return SupportResistanceLevel(
      level: json['level'] ?? "",
      classic: (json['classic'] as num).toDouble(),
      fibonacci: (json['fibonacci'] as num).toDouble(),
      camarilla: (json['camarilla'] as num).toDouble(),

      // IMPORTANT FIX
      scrapedAt: (json['scraped_at'] ?? "").toString(),
    );
  }
}
