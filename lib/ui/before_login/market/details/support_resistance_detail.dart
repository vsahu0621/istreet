import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';

class SupportResistanceDetailScreen extends ConsumerWidget {
  const SupportResistanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sr = ref.watch(supportResistanceProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ White AppBar + black arrow + black title
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Support & Resistance",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),

      body: sr.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Error loading S/R data")),

        data: (list) {
          // Always show blur + lock (same popup UX)
final visible = list;

          return Stack(
            children: [
              // ---------------------------------------------------------
              // 🟣 PARTIAL VISIBLE CARDS (same as popup)
              // ---------------------------------------------------------
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final e = visible[index];

                  final badgeColor = e.level.startsWith("R")
                      ? Colors.red.shade600
                      : Colors.green.shade700;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // LEVEL BADGE
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
                              fontWeight: FontWeight.w800,
                              color: badgeColor,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          e.classic.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ---------------------------------------------------------
              // 🟣 BLUR OVERLAY (same as popup)
              // ---------------------------------------------------------
              Positioned.fill(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),

              // ---------------------------------------------------------
              // 🟣 LOCK MESSAGE (same as popup)
              // ---------------------------------------------------------
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.lock,
                        size: 45,
                        color: Color(0xFF0056D6),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Login to view Support & Resistance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0056D6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
