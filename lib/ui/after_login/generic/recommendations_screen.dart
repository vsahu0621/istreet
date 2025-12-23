/* ---------------------------------------------------------
   lib/ui/after_login/recommendations/recommendations_screen.dart
--------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.construction, size: 48,  color: AppColors.iStreetBlue),
            SizedBox(height: 12),
            Text(
              "This feature is under development",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "We are working on it. Stay tuned!",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
