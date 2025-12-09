// lib/ui/fund/fund_detail_page.dart

import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:istreet/config/theme/app_colors.dart';
import 'package:istreet/providers/fund_chart_provider.dart';

class FundDetailPage extends ConsumerStatefulWidget {
  final String fundName;

  const FundDetailPage({super.key, required this.fundName});

  @override
  ConsumerState<FundDetailPage> createState() => _FundDetailPageState();
}

class _FundDetailPageState extends ConsumerState<FundDetailPage> {
  // Full raw data from API (all points)
  List<String> _allDatesRaw = [];
  List<dynamic> _allNavsRaw = [];
  bool _hasBaseData = false;

  // Processed data for current range (after filter + sampling)
  List<FlSpot> spots = [];
  List<String> datesProcessed = [];
  List<double> navsProcessed = [];

  bool graphReady = false;
  bool _processing = false;

  // 0 = 1M, 1 = 6M, 2 = 1Y, 3 = ALL
  int _selectedRange = 0;

  // Zerodha-style zoom factor for horizontal scroll
  double _zoomFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(fundChartProvider(widget.fundName));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.fundName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
        data: (chart) {
          // ✅ SAFELY read raw lists (avoid Null -> List<String> crash)
          final rawDatesDynamic = chart.chart.dates;
          final rawNavsDynamic = chart.chart.navs;

          final List<dynamic> dates = rawDatesDynamic is List
              ? rawDatesDynamic
              : const [];
          final List<dynamic> navs = rawNavsDynamic is List
              ? rawNavsDynamic
              : const [];

          if (dates.isEmpty || navs.isEmpty) {
            return const Center(child: Text("No chart data available"));
          }

          // Store raw once
          if (!_hasBaseData) {
            _allDatesRaw = dates.map((e) => e.toString()).toList();
            _allNavsRaw = List<dynamic>.from(navs);
            _hasBaseData = true;
          }

          // First-time processing for default range (ALL)
          if (!graphReady && !_processing) {
            _processing = true;
            Future.microtask(() => _processGraph(_selectedRange));
          }

          if (!graphReady) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fundHeader(chart.fundName, chart.latestNav, chart.latestDate),
                const SizedBox(height: 16),
                _returnsRow(chart),
                const SizedBox(height: 12),

                // ⭐ Time-range buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _rangeChip("1M", 0),
                    _rangeChip("6M", 1),
                    _rangeChip("1Y", 2),  
                    _rangeChip("ALL", 3),
                  ],
                ),

                const SizedBox(height: 16),

                // ⭐ Zoomable, horizontally scrollable graph (Zerodha-style)
                _zoomBlocker(_buildZoomableGraph(context)),

                const SizedBox(height: 20),
                const Text(
                  "NAV History",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 10),

                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: datesProcessed.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(datesProcessed[i]),
                      trailing: Text(
                        navsProcessed[i].toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------
  // BLOCK SCROLL TO ALLOW CHART TOUCH
  // ---------------------------------------------------------
  Widget _zoomBlocker(Widget child) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) {},
      onPointerMove: (_) {},
      onPointerSignal: (_) {},
      child: child,
    );
  }

  // ---------------------------------------------------------
  // RANGE BUTTON
  // ---------------------------------------------------------
  Widget _rangeChip(String label, int index) {
    final bool selected = _selectedRange == index;
    return GestureDetector(
      onTap: () {
        if (_selectedRange == index || _processing) return;

        setState(() {
          _selectedRange = index;
          graphReady = false;
          _processing = true;
        });
        _processGraph(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // PROCESS GRAPH DATA IN ISOLATE (FAST) WITH RANGE
  // ---------------------------------------------------------
  Future<void> _processGraph(int rangeIndex) async {
    if (_allDatesRaw.isEmpty || _allNavsRaw.isEmpty) {
      setState(() {
        graphReady = true;
        _processing = false;
      });
      return;
    }

    final encoded = jsonEncode({
      "dates": _allDatesRaw,
      "navs": _allNavsRaw,
      "range": rangeIndex,
    });

    final result = await compute(_isolateGraph, encoded);

    if (!mounted) return;

    setState(() {
      spots = result["spots"];
      datesProcessed = List<String>.from(result["dates"]);
      navsProcessed = List<double>.from(result["navs"]);
      graphReady = true;
      _processing = false;
    });
  }

  // ------------- ISOLATE FUNCTION (FILTER + DOWNSAMPLE) ----
  static Map<String, dynamic> _isolateGraph(String payload) {
    final data = jsonDecode(payload);

    final List<String> rawDates = (data["dates"] as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    final List<dynamic> rawNavs = data["navs"] as List<dynamic>;
    final int rangeIndex = data["range"] as int;

    // Convert NAVs to double safely
    final List<double> navs = rawNavs.map((e) {
      if (e is double) return e;
      if (e is int) return e.toDouble();
      if (e is String) return double.tryParse(e) ?? 0.0;
      return 0.0;
    }).toList();

    final int len = rawDates.length < navs.length
        ? rawDates.length
        : navs.length;
    if (len == 0) {
      return {"spots": <FlSpot>[], "dates": <String>[], "navs": <double>[]};
    }

    final List<String> dates = rawDates.sublist(0, len);
    final List<double> alignedNavs = navs.sublist(0, len);

    // Parse all dates
    final List<DateTime> allDt = dates.map<DateTime>(_parseDate).toList();

    // ----- APPLY TIME RANGE BY DATE -----
    int? daysBack;
    if (rangeIndex == 0) daysBack = 30; // 1M
    if (rangeIndex == 1) daysBack = 180; // 6M
    if (rangeIndex == 2) daysBack = 365; // 1Y
    // 3 -> ALL => daysBack = null

    int startIndex = 0;
    if (daysBack != null) {
      final DateTime lastDate = allDt.last;
      final DateTime minDate = lastDate.subtract(Duration(days: daysBack));

      for (int i = 0; i < allDt.length; i++) {
        if (!allDt[i].isBefore(minDate)) {
          startIndex = i;
          break;
        }
      }
    }

    List<String> visibleDates = dates.sublist(startIndex);
    List<double> visibleNavs = alignedNavs.sublist(startIndex);
    List<DateTime> visibleDt = allDt.sublist(startIndex);

    if (visibleDates.isEmpty) {
      // fallback to full if somehow empty
      visibleDates = dates;
      visibleNavs = alignedNavs;
      visibleDt = allDt;
    }

    // ----- DOWNSAMPLE (MAX 300 POINTS) -----
    const int maxPoints = 300;
    final int step = (visibleDates.length ~/ maxPoints).clamp(
      1,
      visibleDates.length,
    );

    final DateTime firstDate = visibleDt.first;

    final safeSpots = <FlSpot>[];
    final safeDates = <String>[];
    final safeNavs = <double>[];

    for (int i = 0; i < visibleDates.length; i += step) {
      final dt = visibleDt[i];
      final double x = dt.difference(firstDate).inDays.toDouble();

      safeSpots.add(FlSpot(x, visibleNavs[i]));
      safeDates.add(visibleDates[i]);
      safeNavs.add(visibleNavs[i]);
    }

    return {"spots": safeSpots, "dates": safeDates, "navs": safeNavs};
  }

  static DateTime _parseDate(String d) {
    // input format: DD-MM-YYYY
    final parts = d.split("-");
    if (parts.length != 3) return DateTime.now();
    final dd = parts[0].padLeft(2, '0');
    final mm = parts[1].padLeft(2, '0');
    final yyyy = parts[2];
    return DateTime.tryParse("$yyyy-$mm-$dd") ?? DateTime.now();
  }

  // ---------------------------------------------------------
  // ⭐ FINAL ZOOMABLE GRAPH (ZERODHA STYLE)
  // WITH FIXED Y-AXIS + SCROLLABLE GRAPH
  // ---------------------------------------------------------
  Widget _buildZoomableGraph(BuildContext context) {
    if (spots.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text("No chart data"),
      );
    }

    double minY = spots.first.y;
    double maxY = spots.first.y;
    for (var s in spots) {
      if (s.y < minY) minY = s.y;
      if (s.y > maxY) maxY = s.y;
    }

    final double yIntervalRaw = (maxY - minY) / 4;
    final double yInterval = yIntervalRaw <= 0 ? 1 : yIntervalRaw;

    final double minX = spots.first.x;
    final double maxX = spots.last.x;
    final double xRange = maxX - minX;
    final double baseXInterval = xRange / 5; // ✅ NEW LINE 1
    final double xInterval = (baseXInterval / _zoomFactor).clamp(
      1.0,
      xRange,
    ); // ✅ NEW LINE 2

    // 🔍 Width based on number of points + zoom
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseWidth = math.max(screenWidth, spots.length * 8.0);
    final double chartWidth = baseWidth * _zoomFactor;

    return Stack(
      children: [
        Container(
          height: 320,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ⭐ FIXED Y-AXIS (STATIC, NOT SCROLLING)
              SizedBox(
                width: 44,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (i) {
                    final value = maxY - (yInterval * i);
                    return Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(width: 8),

              // ⭐ SCROLLABLE GRAPH AREA ONLY
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: LineChart(
                      LineChartData(
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // ⭐ X-AXIS DATE (MONTH / YEAR)
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: xInterval,
                              getTitlesWidget: (value, meta) =>
                                  _buildBottomTitle(
                                    value,
                                    meta,
                                    spots,
                                    datesProcessed,
                                  ),
                            ),
                          ),
                        ),
                        lineTouchData: LineTouchData(
                          enabled: true,
                          handleBuiltInTouches: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            tooltipRoundedRadius: 8,
                            getTooltipColor: (_) => Colors.white,
                            tooltipBorder: BorderSide(
                              color: AppColors.primaryBlue.withOpacity(0.8),
                              width: 1,
                            ),
                            // ✅ Always return SAME LENGTH list as touchedSpots
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((barSpot) {
                                final idx = barSpot.spotIndex;

                                // Extra guard (should normally be in range)
                                if (idx < 0 ||
                                    idx >= datesProcessed.length ||
                                    idx >= navsProcessed.length) {
                                  return const LineTooltipItem(
                                    '',
                                    TextStyle(fontSize: 0),
                                  );
                                }

                                final dt = _parseDate(datesProcessed[idx]);
                                final dateLabel = DateFormat(
                                  'dd MMM yyyy',
                                ).format(dt);
                                final price = navsProcessed[idx]
                                    .toStringAsFixed(2);

                                return LineTooltipItem(
                                  "$dateLabel\n",
                                  const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "₹$price",
                                      style: TextStyle(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 3,
                            color: AppColors.primaryBlue,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryBlue.withOpacity(0.4),
                                  AppColors.primaryBlue.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ⭐ ZOOM BUTTONS
        Positioned(
          right: 12,
          top: 12,
          child: Column(
            children: [
              _zoomBtn(Icons.add, () {
                setState(() {
                  _zoomFactor = (_zoomFactor + 0.2).clamp(1.0, 5.0);
                });
              }),
              const SizedBox(height: 10),
              _zoomBtn(Icons.remove, () {
                setState(() {
                  _zoomFactor = (_zoomFactor - 0.2).clamp(1.0, 5.0);
                });
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ⭐ BOTTOM X-AXIS TITLE (MONTH / YEAR)
  static Widget _buildBottomTitle(
    double value,
    TitleMeta meta,
    List<FlSpot> spots,
    List<String> datesProcessed,
  ) {
    if (spots.isEmpty || datesProcessed.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find nearest point to this x-value
    int nearestIndex = 0;
    double minDiff = double.infinity;
    for (int i = 0; i < spots.length; i++) {
      final diff = (spots[i].x - value).abs();
      if (diff < minDiff) {
        minDiff = diff;
        nearestIndex = i;
      }
    }

    if (nearestIndex < 0 || nearestIndex >= datesProcessed.length) {
      return const SizedBox.shrink();
    }

    final String rawDate = datesProcessed[nearestIndex];
    final dt = _parseDate(rawDate);
    final label = DateFormat('MMM yyy').format(dt); // e.g. "Jul 24"

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.black87),
      ),
    );
  }

  Widget _zoomBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER + RETURNS
  // ---------------------------------------------------------
  Widget _fundHeader(String name, double nav, String date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            "Latest NAV: ₹${nav.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(
            "Updated: $date",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _returnsRow(dynamic chart) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _chip("1M", chart.returns.oneMonth),
        _chip("6M", chart.returns.sixMonths),
        _chip("1Y", chart.returns.oneYear),
        _chip("3Y", chart.returns.threeYears),
      ],
    );
  }

  Widget _chip(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          "${value.toStringAsFixed(2)}%",
          style: TextStyle(
            color: value >= 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
