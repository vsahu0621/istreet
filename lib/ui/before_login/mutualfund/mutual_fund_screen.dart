import 'package:flutter/material.dart';
import 'package:istreet/ui/before_login/mutualfund/fund_category_result_page.dart';
import 'package:istreet/ui/before_login/mutualfund/mutualfund_search_page.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class MutualFundScreen extends StatelessWidget {
  const MutualFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ HERO SECTION
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.wallet,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mutual Funds",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Invest Smart, Grow Wealth",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MutualFundSearchPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.blue.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Search Mutual Funds...",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ⭐ EQUITY FUNDS SECTION
            _sectionHeader("Equity Funds", Icons.trending_up, const Color(0xFF10B981)),
            const SizedBox(height: 12),
            _gridSection(context, [
              ["Small Cap", Icons.store_mall_directory, const Color(0xFF10B981)],
              ["Mid Cap", Icons.home_work, const Color(0xFF3B82F6)],
              ["Large Cap", Icons.apartment, const Color(0xFF8B5CF6)],
              ["Flexi Cap", Icons.show_chart, const Color(0xFFF59E0B)],
              ["Multi Cap", Icons.scatter_plot, const Color(0xFFEC4899)],
              ["Mid & Large Cap", Icons.domain, const Color(0xFF06B6D4)],
              ["Medium Duration Fund", Icons.lightbulb_outline, const Color(0xFF22C55E)],
              ["Sectoral", Icons.flatware, const Color(0xFF6366F1)],
            ]),

            const SizedBox(height: 24),

            // ⭐ DEBT FUNDS SECTION
            _sectionHeader("Debt Funds", Icons.account_balance, const Color(0xFF6366F1)),
            const SizedBox(height: 12),
            _gridSection(context, [
              ["Credit Risk", Icons.security, const Color(0xFF8B5CF6)],
              ["PSU", Icons.receipt_long, const Color(0xFF3B82F6)],
              ["Low Duration", Icons.hourglass_empty, const Color(0xFF10B981)],
              ["Liquid Fund", Icons.water_drop, const Color(0xFF06B6D4)],
              ["Short", Icons.timer, const Color(0xFFF59E0B)],
              ["Long", Icons.timer_outlined, const Color(0xFFEF4444)],
              ["Overnight Fund", Icons.nightlight_round, const Color(0xFF0EA5E9)],
            ]),

            const SizedBox(height: 24),

            // ⭐ OTHER FUNDS SECTION
            _sectionHeader("Other Funds", Icons.folder_special, const Color(0xFFF59E0B)),
            const SizedBox(height: 12),
            _gridSection(context, [
              ["ELSS", Icons.receipt, const Color(0xFF10B981)],
              ["Contra Fund", Icons.attach_money, const Color(0xFF8B5CF6)],
              ["Equity", Icons.trending_up, const Color(0xFF3B82F6)],
              ["Children", Icons.child_care, const Color(0xFFEC4899)],
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // HEADER WIDGET
  Widget _sectionHeader(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // GRID SECTION
  Widget _gridSection(BuildContext context, List<List<Object>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
        children: items.map((item) {
          final String title = item[0] as String;
          final IconData icon = item[1] as IconData;
          final Color color = item[2] as Color;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FundCategoryResultPage(title: title, apiCategory: title),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Explore",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                  color: color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
