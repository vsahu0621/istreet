import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/generic/community_model.dart';
import 'package:istreet/data/services/generic/community_service.dart';
import 'package:istreet/providers/auth_provider.dart';

final communityDashboardProvider =
    AutoDisposeFutureProvider<CommunityDashboard>((ref) async {
      // 🔁 AUTO REFRESH EVERY 10 SECONDS
      final timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => ref.invalidateSelf(),
      );

      ref.onDispose(() => timer.cancel());

      final authState = ref.watch(authProvider);

      if (!authState.isLoggedIn || authState.token == null) {
        throw Exception("User not logged in");
      }

      final json = await CommunityService.fetchCommunityDashboard(
        ref,
        authState.token!,
      );

      if (json.isEmpty) {
        throw Exception("Empty community response");
      }

      return CommunityDashboard.fromJson(json);
    });

class CommunityDashboard {
  final List<Community> created;
  final List<Community> joined;
  final List<Community> available;
  final bool canCreateMore;

  CommunityDashboard({
    required this.created,
    required this.joined,
    required this.available,
    required this.canCreateMore,
  });

  factory CommunityDashboard.fromJson(Map<String, dynamic> json) {
    return CommunityDashboard(
      created: (json['created_communities'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      joined: (json['joined_communities'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      available: (json['available_communities'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      canCreateMore: json['can_create_more'] ?? false,
    );
  }
}
