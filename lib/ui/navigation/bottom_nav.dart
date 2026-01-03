// lib/ui/navigation/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/config/theme/app_colors.dart';

// GENERIC AFTER LOGIN
import 'package:istreet/ui/after_login/generic/community.dart';
import 'package:istreet/ui/after_login/generic/recommendations_screen.dart';

// BEFORE LOGIN
import '../before_login/home/home_screen.dart';
import '../before_login/market/market_screen.dart';
import '../before_login/news/news_screen.dart';
import '../before_login/mutualfund/mutual_fund_screen.dart';
import '../before_login/auth/sign_in_screen.dart';

// AFTER LOGIN DASHBOARDS
import '../after_login/admin_dashboard_screen.dart';
import '../after_login/advisor_dashboard_screen.dart';
import '../after_login/analyst_dashboard_screen.dart';
import '../after_login/client_dashboard_screen.dart';
import '../after_login/generic_dashboard_screen.dart';

// PROVIDERS
import 'package:istreet/providers/after_login/nav_mode_provider.dart';
import 'package:istreet/providers/auth_provider.dart';

final GlobalKey<NavigatorState> marketNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> newsNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> mutualFundNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> communityNavKey = GlobalKey<NavigatorState>();

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int selectedIndex = 0;

  void handleLoginSuccess(String userType) {
    debugPrint("🎯 BottomNav received userType: $userType");
    ref.read(navModeProvider.notifier).state = AppNavMode.mystreet;
    setState(() => selectedIndex = 0);
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

    // 🔥 READ USER TYPE FROM AUTH PROVIDER
    final auth = ref.watch(authProvider);
    final userType = auth.userType ?? 'generic';

    debugPrint("🔥 BottomNav userType = $userType");

    late final List<Widget> screens;
    late final List<BottomNavigationBarItem> items;

    // ================== GUEST ==================
    if (mode == AppNavMode.guest) {
      screens = [
        HomeScreen(onLoginTap: () => setState(() => selectedIndex = 4)),
        _marketTab(() => setState(() => selectedIndex = 4)),
        _newsTab(),
        _mutualFundTab(),
        LoginScreen(onLoginSuccess: handleLoginSuccess),
      ];

      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News"),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "MFund"),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login"),
      ];

      // ================== MYSTREET ==================
    } else if (mode == AppNavMode.mystreet) {
      screens = [
        _dashboardByUserType(userType), // ✅ FIXED
        const RecommendationsScreen(),
        Navigator(
          key: communityNavKey,
          onGenerateRoute: (_) =>
              MaterialPageRoute(builder: (_) => const CommunityScreen()),
        ),

        IStreetSwitchScreen(onSwitch: switchToIStreet),
      ];

      items = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.recommend),
          label: "Recommendations",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: "Community"),
        BottomNavigationBarItem(icon: Icon(Icons.language), label: "iStreet"),
      ];

      // ================== ISTREET ==================
    } else {
      screens = [
        HomeScreen(onLoginTap: () => setState(() => selectedIndex = 4)),
        _marketTab(() => setState(() => selectedIndex = 4)),
        _newsTab(),
        _mutualFundTab(),
        MyStreetSwitchScreen(onSwitchBack: switchToMyStreet),
      ];

      items = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.auto_graph), label: "Market"),
        BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: "News"),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "MFund"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "MyStreet"),
      ];
    }

    if (selectedIndex >= screens.length) selectedIndex = 0;

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        
        selectedItemColor: AppColors.iStreetBlue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => selectedIndex = i),
        items: items,
      ),
    );
  }
}

// ================== HELPERS ==================

Widget _dashboardByUserType(String userType) {
  switch (userType) {
    case 'admin':
      return const AdminDashboardScreen();
    case 'advisor':
      return const AdvisorDashboardScreen();
    case 'analyst':
      return const AnalystDashboardScreen();
    case 'client':
      return const ClientDashboardScreen();
    default:
      return const GenericDashboardScreen();
  }
}

Widget _marketTab(VoidCallback onLoginTap) {
  return Navigator(
    key: marketNavKey,
    onGenerateRoute: (_) =>
        MaterialPageRoute(builder: (_) => MarketScreen(onLoginTap: onLoginTap)),
  );
}

Widget _newsTab() {
  return Navigator(
    key: newsNavKey,
    onGenerateRoute: (_) =>
        MaterialPageRoute(builder: (_) => const NewsScreen()),
  );
}

Widget _mutualFundTab() {
  return Navigator(
    key: mutualFundNavKey,
    onGenerateRoute: (_) =>
        MaterialPageRoute(builder: (_) => const MutualFundScreen()),
  );
}

// ================== SWITCH SCREENS ==================

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
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onSwitch());
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

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
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onSwitchBack());
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
