import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/ui/before_login/auth/sign_in_screen.dart';
import 'package:istreet/ui/navigation/bottom_nav.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ❗ Auth check yahan nahi
    // ❗ NavMode hi sab decide karega
    return const BottomNav();
  }
}
