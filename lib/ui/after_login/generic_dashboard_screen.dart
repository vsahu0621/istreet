import 'package:flutter/material.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class GenericDashboardScreen extends StatelessWidget {
  const GenericDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CommonAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard("Welcome back!"),
          const SizedBox(height: 20),
          _sectionTitle("Quick Access"),
          _optionCard(Icons.home, "Home", "Go to homepage"),
          _optionCard(Icons.newspaper, "Market News", "Latest stock news"),
          _optionCard(Icons.info, "Insights", "General market insights"),
        ],
      ),
    );
  }

  Widget _headerCard(String text) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
      );

  Widget _optionCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Color(0xFF3B82F6)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
