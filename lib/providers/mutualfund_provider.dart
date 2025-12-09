import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/mutual_fund.dart';
import 'package:istreet/data/services/mutual_fund_service.dart';

final searchFundProvider = FutureProvider.family<List<MutualFund>, String>((
  ref,
  query,
) async {
  final q = query.trim();

  // ⭐ If no search → load ALL data
  if (q.isEmpty) {
    return MutualFundService.searchFundHouse("a"); // use default keyword
  }

  return MutualFundService.searchFundHouse(q);
});
