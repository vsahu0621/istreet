// lib/data/models/fund_chart.dart

class FundChart {
  final String fundName;
  final double latestNav;
  final String latestDate;
  final FundReturns returns;
  final FundChartData chart;

  FundChart({
    required this.fundName,
    required this.latestNav,
    required this.latestDate,
    required this.returns,
    required this.chart,
  });

  factory FundChart.fromJson(Map<String, dynamic> json) {
    return FundChart(
      fundName: (json["fund_name"] ?? "").toString(),
      latestNav: (json["latest_nav"] ?? 0).toDouble(),
      latestDate: (json["latest_date"] ?? "").toString(),
      returns: FundReturns.fromJson(json["returns"] ?? {}),
      chart: FundChartData.fromJson(json["chart"] ?? {}),
    );
  }
}

class FundReturns {
  final double oneMonth;
  final double sixMonths;
  final double oneYear;
  final double threeYears;

  FundReturns({
    required this.oneMonth,
    required this.sixMonths,
    required this.oneYear,
    required this.threeYears,
  });

  factory FundReturns.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      try {
        if (v == null) return 0.0;
        if (v is double) return v;
        if (v is int) return v.toDouble();
        return double.tryParse(v.toString()) ?? 0.0;
      } catch (_) {
        return 0.0;
      }
    }

    return FundReturns(
      oneMonth: parse(json["one_month"]),
      sixMonths: parse(json["six_months"]),
      oneYear: parse(json["one_year"]),
      threeYears: parse(json["three_years"]),
    );
  }
}

class FundChartData {
  final List<String> dates;
  final List<double> navs;
  final int page;
  final int limit;
  final int nextPage;
  final bool hasMore;

  FundChartData({
    required this.dates,
    required this.navs,
    required this.page,
    required this.limit,
    required this.nextPage,
    required this.hasMore,
  });

  factory FundChartData.fromJson(Map<String, dynamic> json) {
    List<String> dates = [];
    List<double> navs = [];

    // parse dates
    final rawDates = json["dates"];
    if (rawDates is List) {
      dates = rawDates.map((e) => (e ?? "").toString()).cast<String>().toList();
    }

    // parse navs robustly
    final rawNavs = json["navs"];
    if (rawNavs is List) {
      navs = rawNavs.map<double>((e) {
        try {
          if (e == null) return 0.0;
          if (e is double) return e;
          if (e is int) return e.toDouble();
          return double.tryParse(e.toString()) ?? 0.0;
        } catch (_) {
          return 0.0;
        }
      }).toList();
    }

    return FundChartData(
      dates: dates,
      navs: navs,
      page: (json["page"] ?? 1) is int
          ? (json["page"] ?? 1) as int
          : int.tryParse("${json["page"]}") ?? 1,
      limit: (json["limit"] ?? 50) is int
          ? (json["limit"] ?? 50) as int
          : int.tryParse("${json["limit"]}") ?? 50,
      nextPage: (json["next_page"] ?? 1) is int
          ? (json["next_page"] ?? 1) as int
          : int.tryParse("${json["next_page"]}") ?? 1,
      hasMore: json["has_more"] == true,
    );
  }
}
