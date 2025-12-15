import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/moving_average_model.dart';
import '../models/fiidii_model.dart';
import '../models/bulk_deal_model.dart';
import '../models/block_deal_model.dart';
import '../models/support_resistance_model.dart';

class MarketService {
  static const _base = "https://istreet.in/istreet-api";

  // ------------------ MOVING AVERAGE ------------------
  static Future<List<MovingAverage>> fetchMovingAverage() async {
    final url = Uri.parse("$_base/get_moving_avrage_api/");

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    List data = body['mva'] ?? [];

    return data.map((e) => MovingAverage.fromJson(e)).toList();
  }

  // ------------------ FII/DII DATA ------------------
  static Future<List<FiiDiiData>> fetchFiiDii() async {
    final url = Uri.parse("$_base/get_market_fiidii_giftynifty/");

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    List data = body['fiidii_data'] ?? [];

    return data.map((e) => FiiDiiData.fromJson(e)).toList();
  }

  // ------------------ BULK DEALS ------------------
  static Future<List<BulkDeal>> fetchBulkDeals() async {
    final url = Uri.parse("$_base/get_bulkdeals_api/");

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    List data = body['bulkdeals'] ?? [];

    return data.map((e) => BulkDeal.fromJson(e)).toList();
  }
   
  // ------------------ BLOCK DEALS ------------------
  static Future<List<BlockDeal>> fetchBlockDeals() async {
    final url = Uri.parse("$_base/get_blockdeal_api/");

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    List data = body['blockdeal'] ?? [];

    return data.map((e) => BlockDeal.fromJson(e)).toList();
  }

  // ------------------ SUPPORT / RESISTANCE ------------------
  static Future<List<SupportResistanceLevel>> fetchSupportResistance() async {
    final url = Uri.parse("$_base/get_support_resistance_api/");

    final response = await http.get(url);
    final body = jsonDecode(response.body);

    List data = body['support_resistance'] ?? [];

    return data.map((e) => SupportResistanceLevel.fromJson(e)).toList();
  }
}
