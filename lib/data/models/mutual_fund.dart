class MutualFund {
  final int id;
  final int schemeCode;
  final String schemeName;
  final String fundHouse;
  final String schemeType;
  final String schemeCategory;
  final String schemeStartDate;
  final String mfImageUrl; // ⭐ NEW

  MutualFund({
    required this.id,
    required this.schemeCode,
    required this.schemeName,
    required this.fundHouse,
    required this.schemeType,
    required this.schemeCategory,
    required this.schemeStartDate,
    required this.mfImageUrl,
  });

  factory MutualFund.fromJson(Map<String, dynamic> json) {
    return MutualFund(
      id: json['id'] ?? 0,
      schemeCode: json['scheme_code'] ?? 0,
      schemeName: json['scheme_name'] ?? "",
      fundHouse: json['fund_house'] ?? "",
      schemeType: json['scheme_type'] ?? "",
      schemeCategory: json['scheme_category'] ?? "",
      schemeStartDate: json['scheme_start_date'] ?? "",
      mfImageUrl: json['mf_image_url'] ?? "", // ⭐ NEW FIELD
    );
  }
}
