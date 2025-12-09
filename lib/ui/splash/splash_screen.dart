import 'dart:async';
import 'package:flutter/material.dart';
import 'package:istreet/ui/navigation/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNav()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove backgroundColor – image already contains background
      body: SizedBox.expand(
        child: Image.asset(
          "assets/images/splash.png",
          fit: BoxFit.cover, // FULL screen, no empty space
        ),
      ),
    );
  }
}
