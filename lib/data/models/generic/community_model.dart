class Community {
  final int id;
  final String name;
  final String description;

  final String? creatorName;
  final String? creatorRole;
  final int? membersCount;

  final bool? canView;
  final bool? canLeave;
  final bool? canJoin;
  final bool? allowUserMessages;

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.creatorName,
    this.creatorRole,
    this.membersCount,
    this.canView,
    this.canLeave,
    this.canJoin,
    this.allowUserMessages,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',

      creatorName: json['creator_name'],
      creatorRole: json['creator_role'],
      membersCount: json['members_count'],

      canView: json['can_view'],
      canLeave: json['can_leave'],
      canJoin: json['can_join'],
      allowUserMessages: json['allow_user_messages'],

    );
  }
}
