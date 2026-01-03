import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/providers/generic/community_provider.dart';
import 'package:istreet/data/services/generic/community_service.dart';
import 'package:istreet/ui/after_login/generic/community_detail_screen.dart';
import 'package:istreet/ui/navigation/bottom_nav.dart';
import '../../../config/theme/app_colors.dart';
import '../../../ui/common_widgets/common_appbar.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(communityDashboardProvider);
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(),
      body: dashboard.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) {
          if (!auth.isLoggedIn) {
            return const Center(
              child: Text("Please login to view communities"),
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
        data: (data) {
          if (!auth.isLoggedIn) {
            return const Center(
              child: Text("Please login to view communities"),
            );
          }

          final userType = ref.read(authProvider).userType;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(communityDashboardProvider);
              await ref.read(communityDashboardProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ================= CREATE COMMUNITY CARD =================
                if (userType == 'analyst' || userType == 'advisor') ...[
                  const Text(
                    "Create Community",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.iStreetBlue.withOpacity(0.05),
                          Colors.purple.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.iStreetBlue.withOpacity(0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.iStreetBlue.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _enhancedStatItem(
                                title: "Created",
                                value: data.created.length.toString(),
                                icon: Icons.groups_rounded,
                                color: AppColors.iStreetBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _enhancedStatItem(
                                title: "Remaining",
                                value: data.canCreateMore
                                    ? (2 - data.created.length).toString()
                                    : "0",
                                icon: Icons.add_circle_outline_rounded,
                                color: data.canCreateMore
                                    ? Colors.green
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: !data.canCreateMore
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: Colors.red.shade600,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Maximum limit reached",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.iStreetBlue,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shadowColor: AppColors.iStreetBlue
                                        .withOpacity(0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () {
                                    _showCreateCommunityDialog(context, ref);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.add_circle_rounded, size: 22),
                                      SizedBox(width: 10),
                                      Text(
                                        "Create New Community",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ================= CREATED =================
                if (data.created.isNotEmpty) ...[
                  _sectionHeader(
                    "Created Communities",
                    data.created.length,
                    Colors.deepPurple,
                  ),
                  const SizedBox(height: 12),
                  ...data.created.map(
                    (c) => _communityCard(
                      context,
                      ref,
                      community: c,
                      primaryText: "VIEW",
                      primaryColor: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ================= JOINED =================
                if (data.joined.isNotEmpty) ...[
                  _sectionHeader(
                    "Joined Communities",
                    data.joined.length,
                    AppColors.iStreetBlue,
                  ),
                  const SizedBox(height: 12),
                  ...data.joined.map(
                    (c) => _communityCard(
                      context,
                      ref,
                      community: c,
                      primaryText: "VIEW",
                      primaryColor: AppColors.iStreetBlue,
                      secondaryText: "LEAVE",
                      secondaryColor: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ================= AVAILABLE =================
                // ================= AVAILABLE =================
                if (data.available.isNotEmpty) ...[
                  _sectionHeader(
                    "Available Communities",
                    data.available.length,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: data.available
                        .map(
                          (c) => _communityCard(
                            context,
                            ref,
                            community: c,
                            primaryText: "JOIN",
                            primaryColor: Colors.green,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= HEADER =================
  Widget _sectionHeader(String title, int count, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("$count", style: TextStyle(color: color)),
        ),
      ],
    );
  }

  // ================= COMMUNITY CARD =================
  Widget _communityCard(
    BuildContext context,
    WidgetRef ref, {
    required dynamic community,
    required String primaryText,
    required Color primaryColor,
    String? secondaryText,
    Color? secondaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.iStreetBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(community.description ?? ""),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Created by: ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text:
                            "${community.creatorName ?? '-'} (${community.creatorRole ?? '-'})",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87, // ✅ SAME as normal Text()
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  "${community.membersCount ?? 0} members",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: primaryText == "VIEW"
                    ? () {
                        communityNavKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => CommunityDetailScreen(
                              communityId: community.id,
                            ),
                          ),
                        );
                      }
                    : primaryText == "JOIN"
                    ? () async {
                        final success = await CommunityService.joinCommunity(
                          communityId: community.id,
                        );
                        if (success) {
                          ref.invalidate(communityDashboardProvider);
                        }
                      }
                    : null,
                child: _actionButton(primaryText, primaryColor),
              ),

              if (secondaryText != null && secondaryColor != null) ...[
                const SizedBox(height: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    final success = await CommunityService.leaveCommunity(
                      communityId: community.id,
                    );
                    if (success) {
                      ref.invalidate(communityDashboardProvider);
                    }
                  },
                  child: _actionButton(secondaryText, secondaryColor),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color) {
    return SizedBox(
      width: 72,
      height: 32,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ================= ENHANCED STAT ITEM =================
  Widget _enhancedStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= STAT ITEM (OLD - NOT USED) =================
Widget _statItem({required String title, required String value}) {
  return Container(
    height: 52,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
          ),
        ),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    ),
  );
}

// ================= CREATE COMMUNITY DIALOG =================
void _showCreateCommunityDialog(BuildContext context, WidgetRef ref) {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      bool allowUserMessages = true; // ✅ checkbox state

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.iStreetBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.group_add_rounded,
                          color: AppColors.iStreetBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Create Community",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ================= NAME =================
                  const Text(
                    "Community Name",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter community name",
                      prefixIcon: Icon(
                        Icons.label_outline_rounded,
                        color: AppColors.iStreetBlue,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.iStreetBlue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= DESCRIPTION =================
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Describe your community...",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.iStreetBlue,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.iStreetBlue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= CHECKBOX =================
                  Row(
                    children: [
                      Checkbox(
                        value: allowUserMessages,
                        activeColor: AppColors.iStreetBlue,
                        onChanged: (value) {
                          setState(() {
                            allowUserMessages = value ?? true;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "Allow user messages",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ================= ACTION BUTTONS =================
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter community name"),
                                ),
                              );
                              return;
                            }

                            final res = await CommunityService.createCommunity(
                              name: nameController.text.trim(),
                              description: descController.text.trim(),
                              allowUserMessages: allowUserMessages,
                            );

                            Navigator.pop(context);

                            if (res["success"] == true) {
                              ref.invalidate(communityDashboardProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Community created successfully!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.iStreetBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Create Community",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
