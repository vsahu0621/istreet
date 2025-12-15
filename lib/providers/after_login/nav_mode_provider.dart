// import 'package:flutter_riverpod/flutter_riverpod.dart';

// enum AppNavMode { istreet, mystreet } 

// final navModeProvider = StateProvider<AppNavMode>((ref) {
//   return AppNavMode.istreet; // default before login
// });
// lib/providers/after_login/nav_mode_provider.dart
// lib/providers/after_login/nav_mode_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppNavMode {
  guest,    // before login (Home | Market | News | MFund | Finance | Login)
  mystreet, // after login (Dashboard | Subscription | Recommendations | Advisory | iStreet)
  istreet,  // iStreet mode (Home | Market | News | MFund | Finance | MyStreet)
}

final navModeProvider = StateProvider<AppNavMode>((ref) => AppNavMode.guest);
