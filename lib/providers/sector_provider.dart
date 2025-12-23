import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/sector_models.dart';
import 'package:istreet/data/services/market/sector_service.dart';

// ✅ DROPDOWN SECTOR LIST
final sectorListProvider = FutureProvider<List<String>>((ref) async {
  return SectorService.fetchSectors();
});

// ✅ SELECTED SECTOR
final selectedSectorProvider = StateProvider<String?>((ref) => null);

// ✅ SECTOR PERFORMANCE DATA
final sectorPerformanceProvider = FutureProvider<SectorPerformanceResponse>((
  ref,
) async {
  final sector = ref.watch(selectedSectorProvider);

  if (sector == null || sector.isEmpty) {
    throw Exception("No sector selected");
  }

  return SectorService.fetchSectorPerformance(sector);
});
