import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectorDetailScreen extends ConsumerWidget {
  const SectorDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sector Details"),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Sector data coming soon...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
