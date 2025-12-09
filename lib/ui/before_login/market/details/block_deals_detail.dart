import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';

class BlockDealsDetailScreen extends ConsumerWidget {
  const BlockDealsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final block = ref.watch(blockDealsProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ White AppBar + black arrow + black title
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Block Deals",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),

      body: block.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (_, __) => const Center(child: Text("Error loading Block Deals")),

        data: (list) {
          // Always show only BLUR + LOCK (SAME AS POPUP)
          return Stack(
            children: [
              // -----------------------------------------------------------------
              // 🔵 PARTIAL VISIBLE DEALS (Same as popup → first 3 items)
              // -----------------------------------------------------------------
              ListView.builder(
                padding: const EdgeInsets.all(16),
                      itemCount: list.length,              
                        itemBuilder: (context, index) {
                  final e = list[index];
                  final isBuy = e.type.toUpperCase() == "BUY";

                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // COMPANY + BUY/SELL TAG
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.company,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isBuy
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                e.type,
                                style: TextStyle(
                                  color: isBuy ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${e.date} • ${e.exchange}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // -----------------------------------------------------------------
              // 🔵 FULL BLUR OVERLAY (Same popup UI)
              // -----------------------------------------------------------------
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

              // -----------------------------------------------------------------
              // 🔒 LOCK MESSAGE (Same popup UI)
              // -----------------------------------------------------------------
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
                        "Login to view Block Deal data",
                        style: TextStyle(
                          color: Color(0xFF0056D6),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
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
