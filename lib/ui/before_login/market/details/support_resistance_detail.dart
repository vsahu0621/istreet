import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:istreet/providers/market_provider.dart';

class SupportResistanceDetailScreen extends ConsumerWidget {
  const SupportResistanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(supportResistanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Support & Resistance")),
      body: data.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final e = list[i];
            return Card(
              child: ListTile(
                title: Text(e.level),
                subtitle: Text(
                    "Classic: ${e.classic}\nFib: ${e.fibonacci}\nCamarilla: ${e.camarilla}"),
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
