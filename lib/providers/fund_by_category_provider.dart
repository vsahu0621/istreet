import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/fund_model.dart';
import 'package:istreet/data/services/fund_service.dart';

final fundByCategoryProvider =
    FutureProvider.family<List<FundModel>, String>((ref, category) {
  return FundService.fetchFundsByCategory(category);
});
