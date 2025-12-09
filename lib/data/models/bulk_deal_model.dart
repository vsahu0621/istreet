class BulkDeal {
  final String date;
  final String symbol;
  final String clientName;
  final String buySell;
  final int quantity;
  final String price;
  final String securityName;

  BulkDeal({
    required this.date,
    required this.symbol,
    required this.clientName,
    required this.buySell,
    required this.quantity,
    required this.price,
    required this.securityName,
  });

  factory BulkDeal.fromJson(Map<String, dynamic> json) {
    return BulkDeal(
      date: json['date'],
      symbol: json['symbol'],
      clientName: json['client_name'],
      buySell: json['buy_sell'],
      quantity: json['quantity_traded'],
      price: json['trade_price'],
      securityName: json['security_name'] ?? '',
    );
  }
}
