// lib/ui/navigation/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/ui/after_login/generic/advisory_screen.dart';
import 'package:istreet/ui/after_login/generic/recommendations_screen.dart';
import 'package:istreet/ui/after_login/generic/subscription_screen.dart';

// import your existing screens (adjust paths if needed)
import '../before_login/home/home_screen.dart';
import '../before_login/market/market_screen.dart';
import '../before_login/news/news_screen.dart';
import '../before_login/mutualfund/mutual_fund_screen.dart';
import '../before_login/finance/my_finance_screen.dart';
import '../before_login/auth/sign_in_screen.dart';

import '../after_login/admin_dashboard_screen.dart';
import '../after_login/advisor_dashboard_screen.dart';
import '../after_login/analyst_dashboard_screen.dart';
import '../after_login/client_dashboard_screen.dart';
import '../after_login/generic_dashboard_screen.dart';

// nav provider
import 'package:istreet/providers/after_login/nav_mode_provider.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int selectedIndex = 0;

  // handle login success from LoginScreen (which sends userType)
  void handleLoginSuccess(String userType) {
    // For now we treat every user as Generic (later branch by userType)
    // 1) Switch nav mode to mystreet
    ref.read(navModeProvider.notifier).state = AppNavMode.mystreet;

    // 2) Reset selected index to a valid index
    setState(() => selectedIndex = 0);

    // Optionally you can store userType in a provider or local storage here.
  }

  void switchToIStreet() {
    ref.read(navModeProvider.notifier).state = AppNavMode.istreet;
    setState(() => selectedIndex = 0);
  }

  void switchToMyStreet() {
    ref.read(navModeProvider.notifier).state = AppNavMode.mystreet;
    setState(() => selectedIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(navModeProvider);

    // Build screens & items based on current mode
    late final List<Widget> screens;
    late final List<BottomNavigationBarItem> items;

    if (mode == AppNavMode.guest) {
      // BEFORE LOGIN
      screens = [
        HomeScreen(onLoginTap: () => setState(() => selectedIndex = 5)),
        MarketScreen(onLoginTap: () => setState(() => selectedIndex = 5)),
        const NewsScreen(),
        const MutualFundScreen(),
        const MyFinanceScreen(),
        // LoginScreen must accept a callback that receives userType
        LoginScreen(onLoginSuccess: handleLoginSuccess),
      ];

      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: "News"),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline_rounded), label: "MFund"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: "Finance"),
        BottomNavigationBarItem(icon: Icon(Icons.login_rounded), label: "Login"),
      ];
    } else if (mode == AppNavMode.mystreet) {
  screens = [
    const GenericDashboardScreen(),     // Dashboard
    const SubscriptionScreen(),         // Subscription
    const RecommendationsScreen(),      // Recommendations
    const AdvisoryScreen(),             // Advisory
    IStreetSwitchScreen(onSwitch: switchToIStreet),
  ];

      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: "Subscription"),
        BottomNavigationBarItem(icon: Icon(Icons.recommend), label: "Recommendations"),
        BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Advisory"),
        BottomNavigationBarItem(icon: Icon(Icons.language), label: "iStreet"),
      ];
    } else {
      // AppNavMode.istreet
      // iStreet navbar: Home | Market | News | MFund | Finance | MyStreet
      screens = [
        HomeScreen(onLoginTap: () => setState(() => selectedIndex = 5)),
        MarketScreen(onLoginTap: () => setState(() => selectedIndex = 5)),
        const NewsScreen(),
        const MutualFundScreen(),
        const MyFinanceScreen(),
        // Last item when tapped should switch back to MyStreet mode
        MyStreetSwitchScreen(onSwitchBack: switchToMyStreet),
      ];

      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: "News"),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline_rounded), label: "MFund"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: "Finance"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "MyStreet"),
      ];
    }

    // Ensure selectedIndex is in bounds for the current screens list
    if (selectedIndex >= screens.length) {
      selectedIndex = screens.length - 1;
    }
    if (selectedIndex < 0) selectedIndex = 0;

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: items,
      ),
    );
  }
}

/* ---------------------------------------------------------
   SMALL HELPER / PLACEHOLDER SCREENS
   Replace these placeholders with your real screens if you have them.
   They are included so this BottomNav file is drop-in runnable.
--------------------------------------------------------- */

class _SubscriptionPlaceholderScreen extends StatelessWidget {
  const _SubscriptionPlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscription")),
      body: const Center(child: Text("Subscription screen (replace me)")),
    );
  }
}

class _RecommendationsPlaceholderScreen extends StatelessWidget {
  const _RecommendationsPlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recommendations")),
      body: const Center(child: Text("Recommendations screen (replace me)")),
    );
  }
}

class _AdvisoryPlaceholderScreen extends StatelessWidget {
  const _AdvisoryPlaceholderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advisory")),
      body: const Center(child: Text("Advisory screen (replace me)")),
    );
  }
}

/// When mystreet's "iStreet" item is tapped, this screen is loaded.
/// It immediately (post frame) triggers the onSwitch callback => changes the nav mode.
class IStreetSwitchScreen extends StatefulWidget {
  final VoidCallback onSwitch;
  const IStreetSwitchScreen({super.key, required this.onSwitch});

  @override
  State<IStreetSwitchScreen> createState() => _IStreetSwitchScreenState();
}

class _IStreetSwitchScreenState extends State<IStreetSwitchScreen> {
  @override
  void initState() {
    super.initState();
    // switch after frame so nav rebuilds safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSwitch();
    });
  }

  @override
  Widget build(BuildContext context) {
    // show a small loader while switching
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

/// When istreet's "MyStreet" item is tapped, this screen is loaded.
/// It switches back to mystreet mode (post frame).
class MyStreetSwitchScreen extends StatefulWidget {
  final VoidCallback onSwitchBack;
  const MyStreetSwitchScreen({super.key, required this.onSwitchBack});

  @override
  State<MyStreetSwitchScreen> createState() => _MyStreetSwitchScreenState();
}

class _MyStreetSwitchScreenState extends State<MyStreetSwitchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSwitchBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
