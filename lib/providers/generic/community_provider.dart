import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/generic/community_model.dart';
import 'package:istreet/data/services/generic/community_service.dart';
import 'package:istreet/providers/auth_provider.dart';

final communityDashboardProvider = FutureProvider<CommunityDashboard?>((
  ref,
) async {
  final authState = ref.watch(authProvider);

  // ✅ Exception mat throw karo
  if (!authState.isLoggedIn || authState.token == null) {
    return null;
  }

  final json = await CommunityService.fetchCommunityDashboard(authState.token!);

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
      created: (json['created'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      joined: (json['joined'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      available: (json['available'] ?? [])
          .map<Community>((e) => Community.fromJson(e))
          .toList(),
      canCreateMore: json['can_create_more'] ?? false,
    );
  }
}
