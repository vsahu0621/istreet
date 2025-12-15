import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';

class BulkDealsDetailScreen extends ConsumerWidget {
  const BulkDealsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulk = ref.watch(bulkDealsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,

        // ✅ AppBar completely white
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          title: const Text(
            "Bulk Deals",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),

          iconTheme: const IconThemeData(color: Colors.black),

          // ❌ Don't put white TabBar directly here  
          // ✅ Use PreferredSize widget with gradient container
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E40AF),
                    Color(0xFF3B82F6),
                    Color(0xFF93C5FD),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Today"),
                  Tab(text: "Last 3 Days"),
                  Tab(text: "Last Week"),
                ],
              ),
            ),
          ),
        ),

        // 🔵 Body
        body: bulk.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text("Error loading Bulk Deals")),
          data: (list) {
            if (list.isEmpty) {
              return const Center(child: Text("No Bulk Deal Data"));
            }

            List filtered(int tab) {
          // Temporarily disable date filtering
         // Because backend dates are old
        return list;
  }


            return TabBarView(
              children: [
                _buildList(filtered(0)),
                _buildList(filtered(1)),
                _buildList(filtered(2)),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------- CARD LIST UI ----------
  Widget _buildList(List items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final e = items[index];
        final isBuy = e.buySell.toUpperCase() == "BUY";

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
              // SYMBOL + BUY/SELL
              Row(
                children: [
                  Expanded(
                    child: Text(
                      e.symbol,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isBuy ? Colors.green.shade100 : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      e.buySell,
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
                e.securityName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Qty: ${e.quantity}",
                      style: const TextStyle(fontSize: 13)),
                  Text(
                    "₹${e.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                "Date: ${e.date}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
