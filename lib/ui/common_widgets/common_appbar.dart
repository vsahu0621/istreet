import 'package:flutter/material.dart';
import 'package:istreet/config/theme/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cardBackground, // White from theme
      elevation: 8, // Same depth as Bottom Nav
      shadowColor: Colors.black12, // Soft shadow
      surfaceTintColor: Colors.transparent, // Removes Material 3 tint

      title: Row(
        children: [
          Image.asset("assets/images/istreetlogo.png", height: 32),
          const SizedBox(width: 8),
          const Text(
            "iStreet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
            color: Color(0xFF1E2A78), // Theme Blue
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
