import 'package:flutter/material.dart';

class MyFinanceScreen extends StatelessWidget {
  const MyFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "MY FINANCE SCREEN",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
