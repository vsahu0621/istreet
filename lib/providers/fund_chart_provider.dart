// lib/providers/fund_chart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/fund_chart.dart';
import 'package:istreet/data/services/fund_chart_service.dart';

final fundChartProvider = FutureProvider.family<FundChart, String>((ref, fundName) async {
  return FundChartService.getFundChart(fundName);
});
