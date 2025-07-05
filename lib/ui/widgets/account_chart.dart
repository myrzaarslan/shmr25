import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccountChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final String currency;

  const AccountChart({
    super.key,
    required this.values,
    required this.labels,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = values.isEmpty ? 1 : values.map((e) => e.abs()).reduce(max);
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: _barTouchData(),
          titlesData: _titlesData(),
          borderData: FlBorderData(show: false),
          barGroups: _barGroups(),
          gridData: const FlGridData(show: false),
          maxY: maxY == 0 ? 1 : maxY.toDouble(),
        ),
      ),
    );
  }

  BarTouchData _barTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
            rod.toY == 1
                ? '0 $currency'
                : '${rod.toY.toStringAsFixed(2)} $currency',
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index == 0 ||
                index == values.length ~/ 2 ||
                index == values.length - 1) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _barGroups() {
    return List.generate(values.length, (i) {
      final val = values[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: val == 0 ? 1 : val.abs().toDouble(),
            color: val < 0
                ? const Color.fromRGBO(255, 95, 0, 1)
                : const Color.fromRGBO(42, 232, 129, 1),
          ),
        ],
      );
    });
  }
}
