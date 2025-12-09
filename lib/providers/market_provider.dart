import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/block_deal_model.dart';
import 'package:istreet/data/models/bulk_deal_model.dart';
import 'package:istreet/data/models/fiidii_model.dart';
import 'package:istreet/data/models/moving_average_model.dart';
import 'package:istreet/data/models/support_resistance_model.dart';
import 'package:istreet/data/services/market_service.dart';


// MOVING AVERAGE
final movingAverageProvider = FutureProvider<List<MovingAverage>>((ref) async {
  return MarketService.fetchMovingAverage();
});

// FII/DII
final fiiDiiProvider = FutureProvider<List<FiiDiiData>>((ref) async {
  return MarketService.fetchFiiDii();
});

// BULK DEALS
final bulkDealsProvider = FutureProvider<List<BulkDeal>>((ref) async {
  return MarketService.fetchBulkDeals();
});

// BLOCK DEALS
final blockDealsProvider = FutureProvider<List<BlockDeal>>((ref) async {
  return MarketService.fetchBlockDeals();
});

// SUPPORT & RESISTANCE
final supportResistanceProvider =
    FutureProvider<List<SupportResistanceLevel>>((ref) async {
  return MarketService.fetchSupportResistance();
});
