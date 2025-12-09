import 'package:flutter/material.dart';
import '../before_login/home/home_screen.dart';
import '../before_login/market/market_screen.dart';
import '../before_login/news/news_screen.dart';
import '../before_login/mutualfund/mutual_fund_screen.dart';
import '../before_login/finance/my_finance_screen.dart';
import '../before_login/auth/login_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  final screens = const [
    HomeScreen(), // 0
    MarketScreen(), // 1
    NewsScreen(), // 2
    MutualFundScreen(), // 3
    MyFinanceScreen(), // 4
    LoginScreen(), // 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        // Tap Handler
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        // Theme Handles Colors + Background
        selectedFontSize: 11,
        unselectedFontSize: 11,
        showSelectedLabels: true,
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_rounded), 
            label: "Market",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: "News",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline_rounded),
            label: "MFund",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_rounded),
            label: "Finance",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.login_rounded),
            label: "Login",
          ),
        ],
      ),
    );
  }
}
