class BlockDeal {
  final String date;
  final String company;
  final String investor;
  final int quantity;
  final double value;
  final double price;
  final String type;
  final String exchange;

  BlockDeal({
    required this.date,
    required this.company,
    required this.investor,
    required this.quantity,
    required this.value,
    required this.price,
    required this.type,
    required this.exchange,
  });

  factory BlockDeal.fromJson(Map<String, dynamic> json) {
    return BlockDeal(
      date: json['date'],
      company: json['company'],
      investor: json['investor'],
      quantity: json['quantity'],
      value: (json['value'] as num).toDouble(),
      price: (json['avg_price'] as num).toDouble(),
      type: json['transaction_type'],
      exchange: json['exchange'] ?? "",
    );
  }
}
