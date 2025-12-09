import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:istreet/providers/market_provider.dart';

class BulkDealsDetailScreen extends ConsumerWidget {
  const BulkDealsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(bulkDealsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Bulk Deals")),
      body: data.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final e = list[i];
            return Card(
              child: ListTile(
                title: Text("${e.symbol} → ${e.buySell}"),
                subtitle: Text(
                    "Qty: ${e.quantity}\nPrice: ${e.price}\nClient: ${e.clientName}"),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Error loading")),
      ),
    );
  }
}
