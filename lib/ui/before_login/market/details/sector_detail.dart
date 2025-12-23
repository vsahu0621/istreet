import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/sector_provider.dart';
import 'package:istreet/ui/common_widgets/insidepage_appbar.dart';

class SectorDetailScreen extends ConsumerWidget {
  const SectorDetailScreen({super.key});

  String formatDate(String date) {
    if (date.length >= 10) {
      return date.substring(2);
    }
    return date;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectorsAsync = ref.watch(sectorListProvider);
    final selectedSector = ref.watch(selectedSectorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const InsidePageAppBar(title: "Sector Details", showTitle: true),
      body: Column(
        children: [
          // ===================== SECTOR SELECTOR CARD =====================
          Container(
            margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: sectorsAsync.when(
              loading: () => _buildLoadingCard(),
              error: (_, __) => _buildErrorCard(),
              data: (sectors) {
                return GestureDetector(
                  onTap: () => _showSectorBottomSheet(context, ref, sectors),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4287F5), Color(0xFF5B9BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4287F5).withOpacity(0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.analytics_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selected Sector",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                selectedSector ?? "Choose a sector",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ===================== PERFORMANCE DATA =====================
          Expanded(
            child: selectedSector == null
                ? _buildEmptyState()
                : ref
                      .watch(sectorPerformanceProvider)
                      .when(
                        loading: () => _buildDataLoading(),
                        error: (_, __) => _buildNoData(),
                        data: (response) {
                          final Map<String, Map<String, double>> companyMap =
                              {};

                          for (final day in response.performance) {
                            for (final stock in day.stocks) {
                              companyMap.putIfAbsent(stock.symbol, () => {});
                              companyMap[stock.symbol]![day.date] =
                                  stock.percentChange;
                            }
                          }

                          final dates = response.performance
                              .map((e) => e.date)
                              .toList();

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                            itemCount: companyMap.entries.length,
                            itemBuilder: (context, index) {
                              final entry = companyMap.entries.elementAt(index);
                              final symbol = entry.key;
                              final values = entry.value;

                              return _buildStockCard(symbol, values, dates);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(
    String symbol,
    Map<String, double> values,
    List<String> dates,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4287F5).withOpacity(0.05),
            const Color(0xFF5B9BFF).withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4287F5).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Stock Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4287F5), Color(0xFF5B9BFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      symbol.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        symbol,
                        style: const TextStyle(
                          color: Color(0xFF1A1F36),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${values.length} trading days",
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.show_chart_rounded,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          // Daily Performance Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Daily Performance",
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Performance Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: dates.map((date) {
                final value = values[date];
                final isPositive = (value ?? 0) >= 0;

                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          (isPositive
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444))
                              .withOpacity(0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value == null
                            ? "--"
                            : "${isPositive ? '+' : ''}${value.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatDate(date),
                        style: TextStyle(
                          fontSize: 10,
                          color: isPositive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4287F5).withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xFF4287F5)),
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "Failed to load sectors",
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4287F5).withOpacity(0.1),
                  const Color(0xFF5B9BFF).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4287F5).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.pie_chart_outline_rounded,
              size: 64,
              color: const Color(0xFF4287F5).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "No Sector Selected",
            style: TextStyle(
              color: Color(0xFF1A1F36),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap above to choose a sector",
            style: TextStyle(
              color: const Color(0xFF1A1F36).withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color(0xFF4287F5)),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: const Color(0xFF4287F5).withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            "No data available",
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showSectorBottomSheet(
    BuildContext context,
    WidgetRef ref,
    List<String> sectors,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF4287F5).withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    "Select Sector",
                    style: TextStyle(
                      color: Color(0xFF1A1F36),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4287F5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFF4287F5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: sectors.length,
                itemBuilder: (context, index) {
                  final sector = sectors[index];
                  final isSelected = sector == ref.read(selectedSectorProvider);

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedSectorProvider.notifier).state = sector;
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF4287F5), Color(0xFF5B9BFF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFF4287F5).withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4287F5,
                                  ).withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF4287F5).withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              sector,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF1A1F36),
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
