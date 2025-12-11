import 'package:flutter/material.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class MyFinanceScreen extends StatelessWidget {
  const MyFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const CommonAppBar(),
      body: Center(
        child: Text(
          "Coming Soon",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
