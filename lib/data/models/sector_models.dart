class SectorPerformanceResponse {
  final List<DailyPerformance> performance;

  SectorPerformanceResponse({required this.performance});

  factory SectorPerformanceResponse.fromJson(Map<String, dynamic> json) {
    return SectorPerformanceResponse(
      performance: (json['performance'] as List)
          .map((e) => DailyPerformance.fromJson(e))
          .toList(),
    );
  }
}

class DailyPerformance {
  final String date;
  final List<StockPerformance> stocks;

  DailyPerformance({required this.date, required this.stocks});

  factory DailyPerformance.fromJson(Map<String, dynamic> json) {
    return DailyPerformance(
      date: json['date'],
      stocks: (json['performance'] as List)
          .map((e) => StockPerformance.fromJson(e))
          .toList(),
    );
  }

  get performance => null;
}

class StockPerformance {
  final String symbol;
  final String companyName;
  final double closePrice;
  final double percentChange;

  StockPerformance({
    required this.symbol,
    required this.companyName,
    required this.closePrice,
    required this.percentChange,
  });

  factory StockPerformance.fromJson(Map<String, dynamic> json) {
    return StockPerformance(
      symbol: json['symbol'],
      companyName: json['company_name'],
      closePrice: (json['close_price'] as num).toDouble(),
      percentChange: (json['percent_change'] as num).toDouble(),
    );
  }
}
