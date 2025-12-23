import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/after_login/nav_mode_provider.dart';
import 'package:istreet/providers/market_provider.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/ui/common_widgets/insidepage_appbar.dart';

class SupportResistanceDetailScreen extends ConsumerWidget {
  final VoidCallback? onLoginTap;

  const SupportResistanceDetailScreen({super.key, this.onLoginTap});

  Color _levelColor(String level) {
    if (level.startsWith("R")) return const Color(0xFFEF4444);
    if (level.startsWith("S")) return const Color(0xFF10B981);
    return const Color(0xFF3B82F6);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sr = ref.watch(supportResistanceProvider);
    //   final isLoggedIn = ref.watch(authProvider).isLoggedIn;
    final mode = ref.watch(navModeProvider);
    final isGuest = mode == AppNavMode.guest;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const InsidePageAppBar(
        title: "Support & Resistance",
        showTitle: true,
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
              /// MAIN LIST UI - SIMPLIFIED CARD DESIGN
              /// **********************************************
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final e = list[index];
                  final levelColor = _levelColor(e.level);
                  final isResistance = e.level.startsWith("R");
                  final isSupport = e.level.startsWith("S");

                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------------------- HEADER: LEVEL + TIME ----------------------
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.level,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: levelColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isResistance
                                    ? Colors.red.shade100
                                    : isSupport
                                    ? Colors.green.shade100
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isResistance
                                    ? "RESISTANCE"
                                    : isSupport
                                    ? "SUPPORT"
                                    : "LEVEL",
                                style: TextStyle(
                                  color: levelColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// ---------------------- TIME SCRAPED ----------------------
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              e.scrapedAt,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// ---------------------- VALUES SECTION ----------------------
                        _buildValueRow(
                          "Classic",
                          e.classic,
                          const Color(0xFF3B82F6),
                        ),
                        const SizedBox(height: 8),
                        _buildValueRow(
                          "Fibonacci",
                          e.fibonacci,
                          const Color(0xFFF59E0B),
                        ),
                        const SizedBox(height: 8),
                        _buildValueRow(
                          "Camarilla",
                          e.camarilla,
                          const Color(0xFF8B5CF6),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// **********************************************
              /// LOCK OVERLAY (BEFORE LOGIN)
              /// **********************************************
              //   if (!isLoggedIn)
              if (isGuest)
                Positioned.fill(
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(color: Colors.white.withOpacity(0.70)),
                    ),
                  ),
                ),

              // if (!isLoggedIn)
              if (isGuest)
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        onLoginTap?.call();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock, size: 48, color: Color(0xFF0056D6)),
                          SizedBox(height: 10),
                          Text(
                            "Login to view Support & Resistance data",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0056D6),
                            ),
                          ),
                        ],
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
  /// SIMPLE VALUE ROW - MATCHING BULK DEALS STYLE
  /// ****************************************************************
  Widget _buildValueRow(String title, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}
