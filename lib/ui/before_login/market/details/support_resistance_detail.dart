import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';
import 'package:istreet/providers/auth_provider.dart';

class SupportResistanceDetailScreen extends ConsumerWidget {
  final VoidCallback? onLoginTap;

  const SupportResistanceDetailScreen({super.key, this.onLoginTap});

  Color _badgeColor(String level) {
    if (level.startsWith("R")) return Colors.red.shade600;
    if (level.startsWith("S")) return Colors.green.shade700;
    return Colors.blue.shade700; // Pivot P
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sr = ref.watch(supportResistanceProvider);
    final isLoggedIn = ref.watch(authProvider).isLoggedIn;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Support & Resistance",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
      ),

      body: sr.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Error loading data")),

        data: (list) {
          return Stack(
            children: [
              /// **********************************************
              /// MAIN LIST UI (ALWAYS VISIBLE)
              /// **********************************************
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final e = list[index];
                  final badgeColor = _badgeColor(e.level);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.blue.shade50.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        )
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------------------- LEVEL + BADGE ----------------------
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: badgeColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                e.level,
                                style: TextStyle(
                                  color: badgeColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Spacer(),

                            Text(
                              "Pivot: ${e.scrapedAt}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// ---------------------- VALUES GRID ----------------------
                        Row(
                          children: [
                            _valueBox("Classic", e.classic, Colors.blue.shade700),
                            const SizedBox(width: 12),
                            _valueBox("Fibonacci", e.fibonacci, Colors.orange.shade700),
                            const SizedBox(width: 12),
                            _valueBox("Camarilla", e.camarilla, Colors.purple.shade700),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// **********************************************
              /// BEFORE LOGIN → SHOW LOCK + BLUR
              /// **********************************************
              if (!isLoggedIn)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.white.withOpacity(0.70),
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock, size: 48, color: Color(0xFF0056D6)),
                          SizedBox(height: 12),
                          Text(
                            "Login to view Support & Resistance",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0056D6),
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.underline,
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
  /// SMALL VALUE BOX WIDGET
  /// ****************************************************************
  Widget _valueBox(String title, double value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
