/* ---------------------------------------------------------
   lib/ui/after_login/recommendations/recommendations_screen.dart
--------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const CommonAppBar(),
      body: const Center(
        child: Text(
          "Recommendations Screen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
