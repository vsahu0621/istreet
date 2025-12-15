import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/providers/market_provider.dart';
import 'package:istreet/ui/before_login/market/details/sector_detail.dart';
import 'package:istreet/ui/common_widgets/common_appbar.dart';
import 'package:istreet/ui/before_login/market/details/bulk_deals_detail.dart';
import 'package:istreet/ui/before_login/market/details/block_deals_detail.dart';
import 'package:istreet/ui/before_login/market/details/support_resistance_detail.dart';

class MarketScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLoginTap;
  
  const MarketScreen({super.key, this.onLoginTap});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}


class _MarketScreenState extends ConsumerState<MarketScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bulkCard(e) {
    final isBuy = e.buySell.toUpperCase() == "BUY";

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SYMBOL + TAG
          Row(
            children: [
              Expanded(
                child: Text(
                  e.symbol,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isBuy ? Colors.green.shade100 : Colors.red.shade100,
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

          // 🔵 SECURITY NAME (NEW) – replacing client_name
          Text(
            e.securityName, // <-- Updated field
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // QUANTITY + PRICE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Qty: ${e.quantity}", style: const TextStyle(fontSize: 13)),
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
  }

  // ---------------------- HELPERS ----------------------
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget animatedSwitcher(Widget child) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: child,
    );
  }

  Widget tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget animatedCard({required int index, required Widget child}) {
    final start = 0.1 * index;
    final end = (start + 0.4).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        );

        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - animation.value)),
            child: child,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🔵 POPUP — BULK DEALS
  // ---------------------------------------------------------------------------
  void _showBulkDealsPopup() {
    final bulk = ref.read(bulkDealsProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.82,
          child: DefaultTabController(
            length: 3,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ---------------- HEADER ----------------
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "Bulk Deals",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 1),

                  // ---------------- TAB BAR ----------------
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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

                  // ---------------- TAB CONTENT ----------------
                  Expanded(
                    child: bulk.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Center(child: Text("No Bulk Deal data"));
                        }

                        // Convert raw date string → DateTime
                        List filtered(int tab) {
                          final today = DateTime.now();

                          return list.where((e) {
                            final date = DateTime.tryParse(e.date) ?? today;

                            if (tab == 0) {
                              // TODAY
                              return date.year == today.year &&
                                  date.month == today.month &&
                                  date.day == today.day;
                            } else if (tab == 1) {
                              // LAST 3 DAYS
                              return date.isAfter(
                                today.subtract(const Duration(days: 3)),
                              );
                            } else {
                              // LAST WEEK
                              return date.isAfter(
                                today.subtract(const Duration(days: 7)),
                              );
                            }
                          }).toList();
                        }

                        return TabBarView(
                          children: [
                            // ---------------- TODAY ----------------
                            ListView(
                              padding: const EdgeInsets.all(16),
                              children: filtered(
                                0,
                              ).map((e) => _bulkCard(e)).toList(),
                            ),

                            // ---------------- LAST 3 DAYS ----------------
                            ListView(
                              padding: const EdgeInsets.all(16),
                              children: filtered(
                                1,
                              ).map((e) => _bulkCard(e)).toList(),
                            ),

                            // ---------------- LAST WEEK ----------------
                            ListView(
                              padding: const EdgeInsets.all(16),
                              children: filtered(
                                2,
                              ).map((e) => _bulkCard(e)).toList(),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) =>
                          const Center(child: Text("Error loading Bulk Deals")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🔴 POPUP — BLOCK DEALS (LOCKED)
  // ---------------------------------------------------------------------------

  void _showBlockDealsPopup() {
    final block = ref.read(blockDealsProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.82,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Block Deals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),

                Expanded(
                  child: Stack(
                    children: [
                      block.when(
                        data: (list) {
                          final visible = list.take(3).toList();

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: visible.length,
                            itemBuilder: (context, index) {
                              final e = visible[index];
                              final isBuy = e.type.toUpperCase() == "BUY";

                              return Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isBuy
                                                ? Colors.green.shade100
                                                : Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            e.type,
                                            style: TextStyle(
                                              color: isBuy
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${e.date} • ${e.exchange}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) =>
                            const Center(child: Text("Error loading data")),
                      ),

                      // FULL BLUR LOCK
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),

                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.lock,
                                size: 42,
                                color: Color(0xFF0056D6),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Login to view Block Deal data",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0056D6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🟣 POPUP — SUPPORT & RESISTANCE (LOCKED)
  // ---------------------------------------------------------------------------

  void _showSupportResistancePopup() {
    final sr = ref.read(supportResistanceProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.82,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Support & Resistance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 1),

                Expanded(
                  child: Stack(
                    children: [
                      sr.when(
                        data: (list) {
                          final visible = list.take(3).toList();

                          return ListView.builder(
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
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
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
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) =>
                            const Center(child: Text("Error loading S/R data")),
                      ),

                      // FULL BLUR
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),

                      // LOCK
                      Positioned.fill(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.lock,
                                size: 42,
                                color: Color(0xFF0056D6),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Login to view Support & Resistance",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0056D6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final mva = ref.watch(movingAverageProvider);
    final fii = ref.watch(fiiDiiProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // MOVING AVERAGES
            // ------------------------------------------------------------
            animatedCard(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Moving Averages",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),

                  animatedSwitcher(
                    mva.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Text("No Moving Average data");
                        }

                        return SizedBox(
                          height: 155,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              final isBullish = item.ma50 > item.ma200;
                              final range = item.yh - item.yl;
                              final current =
                                  (item.ma50 - item.yl) /
                                  (range == 0 ? 1 : range);

                              return Container(
                                width: 220,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12.withOpacity(0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.symbol,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        if (isBullish)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(
                                                0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Text(
                                              "Bullish",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "200D",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                item.ma200.toStringAsFixed(0),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "50D",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                item.ma50.toStringAsFixed(0),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Low: ${item.yl.toStringAsFixed(0)}",
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "High: ${item.yh.toStringAsFixed(0)}",
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: current.clamp(0, 1),
                                        minHeight: 5,
                                        backgroundColor: Colors.grey.shade300,
                                        valueColor: AlwaysStoppedAnimation(
                                          isBullish ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) =>
                          const Text("Error loading Moving Average data"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ------------------------------------------------------------
            // TOP BUTTONS
            // ------------------------------------------------------------
            Row(
  children: [
    // BULK
    Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BulkDealsDetailScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF059669)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              Icon(Icons.trending_up, color: Colors.white),
              SizedBox(height: 4),
              Text("Bulk Deals",
                  style: TextStyle(color: Colors.white, fontSize: 13)),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 12),

    // BLOCK
    Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlockDealsDetailScreen(
            onLoginTap: widget.onLoginTap,   // ✅ FIXED
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.view_module, color: Colors.white),
          SizedBox(height: 4),
          Text("Block Deals",
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    ),
  ),
),

    const SizedBox(width: 12),

   // S&R
Expanded(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SupportResistanceDetailScreen(
            onLoginTap: widget.onLoginTap,   // ✅ ADDED
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Icon(Icons.show_chart, color: Colors.white),
          SizedBox(height: 4),
          Text("S & R",
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    ),
  ),
),


    const SizedBox(width: 12),

    // ⭐ NEW SECTOR BOX
    Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SectorDetailScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFD97706)], // Yellow theme
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              Icon(Icons.category, color: Colors.white),
              SizedBox(height: 4),
              Text(
                "Sector",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),


            const SizedBox(height: 22),

            // ------------------------------------------------------------
            // FII – DII SECTION
            // ------------------------------------------------------------
            animatedCard(
              index: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sectionTitle("📊 FII–DII Data"),

                    animatedSwitcher(
                      fii.when(
                        data: (list) {
                          if (list.isEmpty) return const Text("No data");

                          final latest = list.first;

                          Widget valueText(double v) {
                            final pos = v >= 0;
                            return Text(
                              "${pos ? '+' : ''}${v.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: pos ? Colors.green : Colors.red,
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Live • ${latest.date}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),

                              GridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.6,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                children: [
                                  _dataCard(
                                    "Net Cash",
                                    latest.netCash,
                                    Icons.savings,
                                    Colors.green.shade50,
                                  ),
                                  _dataCard(
                                    "FII Cash",
                                    latest.fiiCash,
                                    Icons.wallet,
                                    Colors.red.shade50,
                                  ),
                                  _dataCard(
                                    "DII Cash",
                                    latest.diiCash,
                                    Icons.show_chart,
                                    Colors.green.shade50,
                                  ),
                                  _dataCard(
                                    "Net Derivatives",
                                    latest.netDerivatives,
                                    Icons.timeline,
                                    Colors.green.shade50,
                                  ),
                                  _dataCard(
                                    "FII Index FUT",
                                    latest.fiiIdxFut,
                                    Icons.trending_up,
                                    Colors.red.shade50,
                                  ),
                                  _dataCard(
                                    "FII Index OPT",
                                    latest.fiiIdxOpt,
                                    Icons.timeline,
                                    Colors.green.shade50,
                                  ),
                                  _dataCard(
                                    "FII Stock FUT",
                                    latest.fiiStkFut,
                                    Icons.show_chart,
                                    Colors.red.shade50,
                                  ),
                                  _dataCard(
                                    "FII Stock OPT",
                                    latest.fiiStkOpt,
                                    Icons.bolt,
                                    Colors.green.shade50,
                                  ),
                                ],
                              ),

                              // const SizedBox(height: 8),
                              // Align(
                              //   alignment: Alignment.centerRight,
                              //   child: TextButton(
                              //     child: const Text("View More →"),
                              //     onPressed: () => Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (_) =>
                              //             const FiiDiiDetailScreen(),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) =>
                            const Text("Error loading FII-DII data"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Small Card Generator
  Widget _dataCard(String title, double value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value >= 0
                ? "+${value.toStringAsFixed(2)}"
                : value.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: value >= 0 ? Colors.green : Colors.red,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

