/* ---------------------------------------------------------
   lib/ui/after_login/advisory/advisory_screen.dart
--------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class AdvisoryScreen extends StatelessWidget {
  const AdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const CommonAppBar(),
      body: const Center(
        child: Text(
          "Advisory Screen",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
