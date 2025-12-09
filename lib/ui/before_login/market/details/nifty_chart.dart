import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class NiftyMiniChart extends StatelessWidget {
  final List<double> values;
  final bool isPositive;

  const NiftyMiniChart({
    super.key,
    required this.values,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("No Chart Data")),
      );
    }

    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          minY: values.reduce((a, b) => a < b ? a : b),
          maxY: values.reduce((a, b) => a > b ? a : b),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),

          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
              isCurved: true,
              color: isPositive ? Colors.green : Colors.red,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    (isPositive ? Colors.green : Colors.red).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
