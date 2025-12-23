import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/ui/splash/splash_screen.dart';
import 'ui/navigation/bottom_nav.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: IStreetApp()));
}

class IStreetApp extends StatelessWidget {
  const IStreetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iStreet',
      theme: AppTheme.light,
      // home: const BottomNav(),
      home: const SplashScreen(),
    );
  }
}
