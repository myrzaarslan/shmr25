import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AccountChart extends StatelessWidget {
  final List<double> incomes;
  final List<double> expenses;
  final List<String> labels;
  final String currency;

  const AccountChart({
    super.key,
    required this.incomes,
    required this.expenses,
    required this.labels,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final maxY = [
      ...incomes.map((e) => e.abs()),
      ...expenses.map((e) => e.abs()),
    ].fold<double>(0, (prev, e) => e > prev ? e : prev);
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
            '${rod.toY.toStringAsFixed(2)} $currency',
            TextStyle(
              color: rod.color == Colors.green ? Colors.green : Colors.red,
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
                index == labels.length ~/ 2 ||
                index == labels.length - 1) {
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
    return List.generate(labels.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: incomes[i],
            color: Colors.green,
            width: 7,
          ),
          BarChartRodData(
            toY: -expenses[i],
            color: Colors.red,
            width: 7,
          ),
        ],
        barsSpace: 2,
      );
    });
  }
}
