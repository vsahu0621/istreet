import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/core/utils/responsive.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';
import 'package:istreet/ui/before_login/auth/sign_in_screen.dart';
import '../../../providers/istreet_connect_provider.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback? onLoginTap;
  const HomeScreen({super.key, this.onLoginTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiData = ref.watch(istreetConnectProvider);
    final scale = Responsive.scale(context);
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------------
            // HERO BANNER
            // --------------------------------------------------------
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.deepBlue,
                    AppColors.indigo,
                    AppColors.violet,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.indigo.withOpacity(0.4),

                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -30,
                    right: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Not Only Data, All\nYou Need to Outperform',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Discover the power of data-driven trading strategies and optimize your investments with advanced analytics.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --------------------------------------------------------
            // QUICK FEATURE PILLS
            // --------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _quickFeaturePill(
                      icon: Icons.lightbulb_outline,
                      label: 'Insights',
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.successGreen,
                          AppColors.successGreenDark,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickFeaturePill(
                      icon: Icons.touch_app,
                      label: 'Usability',
                      gradient: const LinearGradient(
                        colors: [AppColors.infoBlue, AppColors.infoBlueDark],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _quickFeaturePill(
                      icon: Icons.visibility,
                      label: 'Transparent',
                      gradient: const LinearGradient(
                        colors: [AppColors.warningYellow, AppColors.dangerRed],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // SECTION HEADER
            // --------------------------------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Core Features',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,

                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Everything you need to succeed',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,

                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------------
            // FEATURE CARDS
            // --------------------------------------------------------
            _premiumFeatureCard(
              context: context,
              image: "assets/images/market.png",
              title: "Market Insights",
              subtitle: "Real-time Analysis",
              description:
                  "Stay updated with real-time stock analysis and AI-driven insights. Deep technical analysis with expert insights to help you make data-backed decisions.",
              accentColor: AppColors.successGreen,
            ),

            const SizedBox(height: 16),

            _premiumFeatureCard(
              context: context,
              image: "assets/images/invest.png",
              title: "Investment Strategies",
              subtitle: "Portfolio Planning",
              description:
                  "Optimize your trading with proven strategies and portfolio planning. Our AI-powered strategies minimize risks and maximize gains for long-term success.",
              accentColor: AppColors.infoBlue,
            ),

            const SizedBox(height: 16),

            _premiumFeatureCard(
              context: context,
              image: "assets/images/secure.png",
              title: "Secure Transactions",
              subtitle: "Bank-grade Protection",
              description:
                  "Trade with confidence using bank-grade encryption and fraud protection. Advanced security ensures safe transactions and encrypted personal data.",
              accentColor: AppColors.violet,
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // STATS CARD
            // --------------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.secondaryBlue, AppColors.infoBlue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.warningYellow,

                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Our Impact',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                        icon: Icons.people,
                        value: '5+',
                        label: 'Analysts',
                        color: AppColors.statsBlue,
                      ),
                      _statItem(
                        icon: Icons.trending_up,
                        value: '10+',
                        label: 'Investors',
                        color: AppColors.statsGreen,
                      ),
                      _statItem(
                        icon: Icons.bar_chart,
                        value: '82%',
                        label: 'Success',
                        color: AppColors.statsPurple,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // WHY CHOOSE
            // --------------------------------------------------------
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Why Choose iStreet?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
            ),

            const SizedBox(height: 16),

            _benefitCard(
              icon: Icons.insights,
              title: 'Smart Market Insights',
              description: 'Real-time data made simple.',
              colors: const [
                AppColors.successGreen,
                AppColors.successGreenDark,
              ],
            ),
            const SizedBox(height: 12),

            _benefitCard(
              icon: Icons.devices,
              title: 'Easy-to-Use Platform',
              description: 'Clean, smooth experience.',
              colors: const [AppColors.infoBlue, AppColors.infoBlueDark],
            ),
            const SizedBox(height: 12),

            _benefitCard(
              icon: Icons.visibility,
              title: 'Transparent Research Tools',
              description: 'Clear insights without the noise.',
              colors: const [AppColors.purple, AppColors.purpleDark],
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // ANALYST CTA
            // --------------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    AppColors.indigo,
                    AppColors.violet,
                    AppColors.deepBlue,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.people,
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
                              'For Analysts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'Monetize your expertise',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _analystBenefit(
                          Icons.bar_chart,
                          'Monetize research & build revenue',
                        ),
                        const SizedBox(height: 12),
                        _analystBenefit(
                          Icons.speed,
                          'Access powerful analytics tools',
                        ),
                        const SizedBox(height: 12),
                        _analystBenefit(
                          Icons.people,
                          'Connect with investors nationwide',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onLoginTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF8B5CF6),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Register as Analyst',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------------------------------------------------
            // FINAL CTA
            // --------------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [AppColors.deepBlue, AppColors.infoBlue],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to iStreet!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your finance journey begins here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: onLoginTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1E40AF),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Free Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _quickFeaturePill({
    required IconData icon,
    required String label,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumFeatureCard({
    required BuildContext context,
    required String image,
    required String title,
    required String subtitle,
    required String description,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _benefitCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> colors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors[0].withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: colors),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _analystBenefit(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
