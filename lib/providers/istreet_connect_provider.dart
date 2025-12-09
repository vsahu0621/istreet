import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/istreet_connect_repo.dart';

final istreetConnectProvider =
    FutureProvider.autoDispose<dynamic>((ref) async {
  return IStreetConnectRepo().fetchConnectData();
});
