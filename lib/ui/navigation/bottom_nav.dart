import 'package:flutter/material.dart';
import '../before_login/home/home_screen.dart';
import '../before_login/market/market_screen.dart';
import '../before_login/news/news_screen.dart';
import '../before_login/mutualfund/mutual_fund_screen.dart';
import '../before_login/finance/my_finance_screen.dart';
import '../before_login/auth/sign_in_screen.dart';

// add your dashboard imports
import '../after_login/admin_dashboard_screen.dart';
import '../after_login/advisor_dashboard_screen.dart';
import '../after_login/analyst_dashboard_screen.dart';
import '../after_login/client_dashboard_screen.dart';
import '../after_login/generic_dashboard_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      HomeScreen(onLoginTap: goToLogin),
      MarketScreen(onLoginTap: goToLogin),
      const NewsScreen(),
      const MutualFundScreen(),
      const MyFinanceScreen(),
      // Note: LoginScreen now expects a callback void Function(String)
      LoginScreen(onLoginSuccess: onLoginSuccess),
    ];
  }

  // 👇 Home → Login tab open
  void goToLogin() {
    setState(() {
      selectedIndex = 5;
    });
  }

  // 👇 Login success → receives userType and open appropriate dashboard
  void onLoginSuccess(String userType) {
    // Map userType to dashboard widget
    Widget dashboard;
    switch (userType.toLowerCase()) {
      case 'admin':
        dashboard = const AdminDashboardScreen();
        break;
      case 'advisor':
        dashboard = const AdvisorDashboardScreen();
        break;
      case 'analyst':
        dashboard = const AnalystDashboardScreen();
        break;
      case 'client':
        dashboard = const ClientDashboardScreen();
        break;
      default:
        dashboard = const GenericDashboardScreen();
        break;
    }

    // Replace entire BottomNav with dashboard
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => dashboard),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.auto_graph_rounded), label: "Market"),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper_rounded), label: "News"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline_rounded), label: "MFund"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_rounded), label: "Finance"),
          BottomNavigationBarItem(icon: Icon(Icons.login_rounded), label: "Login"),
        ],
      ),
    );
  }
}
