import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/data/services/auth_storage.dart';
import 'package:istreet/providers/after_login/nav_mode_provider.dart';
import 'package:istreet/providers/auth_provider.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showLogout;

  const CommonAppBar({super.key, this.showLogout = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.cardBackground,
      elevation: 8,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,

      title: Row(
        children: [
          SvgPicture.asset(
            "assets/images/istreetlogo.svg",
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 8),
          const Text(
            "iStreet",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.iStreetBlue,
            ),
          ),
        ],
      ),

      // 🔵 Attractive Circular Logout
      actions: [
        if (showLogout)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                // 1️⃣ Logout (API nahi chahiye)
                ref.read(authProvider.notifier).logout();

                // 2️⃣ Login flag false
                AuthStorage.setLoggedIn(false);
                print(ref.read(authProvider).isLoggedIn); // SHOULD PRINT false

                // 3️⃣ 🔥 IMPORTANT: Switch nav to GUEST
                ref.read(navModeProvider.notifier).state = AppNavMode.guest;
                // 3️⃣ Root screen pe wapas jao
                Navigator.of(context).popUntil((route) => route.isFirst);
              },

              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF4287F5), // 🔥 Your color
                ),
                child: const Icon(
                  Icons.power_settings_new, // 🔥 Better than logout icon
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
