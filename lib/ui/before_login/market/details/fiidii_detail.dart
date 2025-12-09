import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';


class FiiDiiDetailScreen extends ConsumerWidget {
  const FiiDiiDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(fiiDiiProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("FII / DII Data")),
      body: data.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final e = list[i];
            return Card(
              child: ListTile(
                title: Text("Date: ${e.date}"),
                subtitle: Text(
                  "Nifty: ${e.niftyValue}\n"
                  "Change: ${e.niftyChange}\n"
                  "FII Cash: ${e.fiiCash}\n"
                  "DII Cash: ${e.diiCash}\n"
                  "Net Cash: ${e.netCash}",
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
