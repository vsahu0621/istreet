import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';
import 'package:istreet/providers/auth_provider.dart';

class SupportResistanceDetailScreen extends ConsumerWidget {
  final VoidCallback? onLoginTap;

  const SupportResistanceDetailScreen({super.key, this.onLoginTap});

  Color _levelColor(String level) {
    if (level.startsWith("R")) return const Color(0xFFEF4444);
    if (level.startsWith("S")) return const Color(0xFF10B981);
    return const Color(0xFF3B82F6);
  }

  LinearGradient _levelGradient(String level) {
    if (level.startsWith("R")) {
      return LinearGradient(
        colors: [
          const Color(0xFFEF4444).withOpacity(0.1),
          const Color(0xFFFEE2E2),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (level.startsWith("S")) {
      return LinearGradient(
        colors: [
          const Color(0xFF10B981).withOpacity(0.1),
          const Color(0xFFD1FAE5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [
        const Color(0xFF3B82F6).withOpacity(0.1),
        const Color(0xFFDBEAFE),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sr = ref.watch(supportResistanceProvider);
    final isLoggedIn = ref.watch(authProvider).isLoggedIn;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: const Text(
          "Support & Resistance",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontSize: 20,
          ),
        ),
      ),

      body: sr.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
        ),
        error: (_, __) => const Center(
          child: Text(
            "Error loading data",
            style: TextStyle(color: Color(0xFF64748B)),
          ),
        ),

        data: (list) {
          return Stack(
            children: [
              /// **********************************************
              /// MAIN LIST UI
              /// **********************************************
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final e = list[index];
                  final levelColor = _levelColor(e.level);
                  final gradient = _levelGradient(e.level);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: levelColor.withOpacity(0.08),
                          offset: const Offset(0, 8),
                          blurRadius: 24,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// ---------------------- HEADER WITH GRADIENT ----------------------
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: levelColor.withOpacity(0.2),
                                      offset: const Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  e.level,
                                  style: TextStyle(
                                    color: levelColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 22,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 12,
                                      color: levelColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      e.scrapedAt,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: levelColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ---------------------- VALUES SECTION ----------------------
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildPremiumValueRow(
                                "Classic",
                                e.classic,
                                const Color(0xFF3B82F6),
                                Icons.bar_chart_rounded,
                              ),
                              const SizedBox(height: 12),
                              _buildPremiumValueRow(
                                "Fibonacci",
                                e.fibonacci,
                                const Color(0xFFF59E0B),
                                Icons.trending_up_rounded,
                              ),
                              const SizedBox(height: 12),
                              _buildPremiumValueRow(
                                "Camarilla",
                                e.camarilla,
                                const Color(0xFF8B5CF6),
                                Icons.show_chart_rounded,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// **********************************************
              /// LOCK OVERLAY (BEFORE LOGIN)
              /// **********************************************
              if (!isLoggedIn)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ),

              if (!isLoggedIn)
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onLoginTap?.call();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              offset: const Offset(0, 8),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.lock_rounded,
                              size: 48,
                              color: Colors.white,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "Login to Unlock",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "View Support & Resistance levels",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// ****************************************************************
  /// PREMIUM VALUE ROW
  /// ****************************************************************
  Widget _buildPremiumValueRow(
    String title,
    double value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.25),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          // Icon(
          //   Icons.arrow_forward_ios_rounded,
          //   size: 14,
          //   color: color.withOpacity(0.4),
          // ),
        ],
      ),
    );
  }
}