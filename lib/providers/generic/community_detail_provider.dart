// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:istreet/data/models/generic/community_detail_model.dart';
// import 'package:istreet/data/services/generic/community_service.dart';

// final communityDetailProvider =
//     FutureProvider.family<CommunityDetail, int>((ref, id) async {
//   final json = await CommunityService.fetchCommunityDetail(ref, id);
//   return CommunityDetail.fromJson(json);
// });
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/generic/community_detail_model.dart';
import 'package:istreet/data/services/generic/community_service.dart';

final communityDetailProvider =
    AutoDisposeFutureProviderFamily<CommunityDetail, int>((ref, communityId) async {

  // 🔁 AUTO REFRESH EVERY 3 SECONDS
  final timer = Timer.periodic(
    const Duration(seconds: 3),
    (_) => ref.invalidateSelf(),
  );

  // 🧹 CLEANUP
  ref.onDispose(() => timer.cancel());

  final json = await CommunityService.fetchCommunityDetail(ref, communityId);
  return CommunityDetail.fromJson(json);
});
