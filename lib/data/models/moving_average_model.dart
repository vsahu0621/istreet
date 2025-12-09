class MovingAverage {
  final String symbol;
  final double ma200;
  final double ma50;
  final double yh;
  final double yl;

  MovingAverage({
    required this.symbol,
    required this.ma200,
    required this.ma50,
    required this.yh,
    required this.yl,
  });

  factory MovingAverage.fromJson(Map<String, dynamic> json) {
    return MovingAverage(
      symbol: json['symbol'] ?? "",
      ma200: (json['moving_avg200'] ?? 0).toDouble(),
      ma50: (json['moving_avrage50'] ?? 0).toDouble(), // API spelling wrong but OK
      yh: (json['yh'] ?? 0).toDouble(),
      yl: (json['yl'] ?? 0).toDouble(),
    );
  }
}
