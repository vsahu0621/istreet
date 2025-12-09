import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';

class BlockDealsDetailScreen extends ConsumerWidget {
  const BlockDealsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(blockDealsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Block Deals")),
      body: data.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final e = list[i];
            return Card(
              child: ListTile(
                title: Text("${e.company} → ${e.type}"),
                subtitle: Text(
                  "Qty: ${e.quantity}\nPrice: ${e.price}\nInvestor: ${e.investor}",
                ),
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
