import 'package:flutter/material.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/ui/before_login/mutualfund/fund_category_result_page.dart';
import 'package:istreet/ui/before_login/mutualfund/mutualfund_search_page.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';

class MutualFundScreen extends StatelessWidget {
  const MutualFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: const CommonAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ SEARCH BAR
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
                  horizontal: 18,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.25),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.blueAccent.shade400,
                      size: 26,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      "Search Mutual Funds...",
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ⭐ EQUITY FUNDS SECTION
            _header("Equity Funds"),
            const SizedBox(height: 16),
            _gridSection(context, [
              ["Small Cap", Icons.store_mall_directory],
              ["Mid Cap", Icons.home_work],
              ["Large Cap", Icons.apartment],
              ["Flexi Cap", Icons.show_chart],
              ["Multi Cap", Icons.scatter_plot],
              ["Mid & Large Cap", Icons.domain],
              ["Medium Duration Fund", Icons.lightbulb_outline],
              ["Sectoral", Icons.flatware],
            ]),

            const SizedBox(height: 35),

            // ⭐ DEBT FUNDS SECTION
            _header("Debt Funds"),
            const SizedBox(height: 16),
            _gridSection(context, [
              ["Credit Risk", Icons.security],
              ["PSU", Icons.receipt_long],
              ["Low Duration", Icons.hourglass_empty],
              ["Liquid Fund", Icons.water_drop],
              ["Short", Icons.timer],
              ["Long", Icons.timer_outlined],
              ["Overnight Fund", Icons.nightlight_round],
            ]),

            const SizedBox(height: 35),

            // ⭐ OTHER FUNDS SECTION
            _header("Other Funds"),
            const SizedBox(height: 16),
            _gridSection(context, [
              ["ELSS", Icons.receipt],
              ["Contra Fund", Icons.attach_money],
              ["Equity", Icons.trending_up],
              ["Children", Icons.child_care],
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ⭐ UPDATED gridSection WITH onTap → Search Page
  Widget _gridSection(BuildContext context, List<List<Object>> items) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.15,
      children: items.map((item) {
        final title = item[0] as String;
        final icon = item[1] as IconData;

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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.25),
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 53, 129, 234),
                        Color.fromARGB(255, 126, 175, 255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(icon, size: 40, color: Colors.white),
                ),

                const SizedBox(height: 12),

                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 53, 129, 234),
                        Color.fromARGB(255, 126, 175, 255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
