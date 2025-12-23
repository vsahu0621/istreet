import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:istreet/config/theme/app_colors.dart';

class InsidePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showTitle;

  const InsidePageAppBar({super.key, this.title = "", this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.cardBackground,
      elevation: 8,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back, // ✅ PROPER ARROW ICON
          color: Colors.black,
          size: 26,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: showTitle
          ? Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                // color: AppColors.iStreetBlue,
                color: Colors.black,
              ),
            )
          : null,

      centerTitle: false,

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              SvgPicture.asset("assets/images/istreetlogo.svg", height: 28),
              const SizedBox(width: 6),
              const Text(
                "iStreet",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.iStreetBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
