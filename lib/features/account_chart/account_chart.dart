import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AccountChart extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final bool isMonthly;
  final String currency;
  final ValueChanged<bool>? onModeChanged;
  const AccountChart({
    super.key,
    required this.values,
    required this.labels,
    required this.isMonthly,
    required this.currency,
    this.onModeChanged,
  });

  @override
  State<AccountChart> createState() => _AccountChartState();
}

class _AccountChartState extends State<AccountChart> {
  late bool _isMonthly;

  @override
  void initState() {
    super.initState();
    _isMonthly = widget.isMonthly;
  }

  @override
  void didUpdateWidget(covariant AccountChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isMonthly != widget.isMonthly) {
      _isMonthly = widget.isMonthly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SegmentedButton(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment(value: false, label: Text('По дням')),
                ButtonSegment(value: true, label: Text('По месяцам')),
              ],
              selected: {_isMonthly},
              onSelectionChanged: (s) {
                setState(() => _isMonthly = s.first);
                widget.onModeChanged?.call(_isMonthly);
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.white,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY >= 0 ? '' : '-'}${rod.toY.abs().toStringAsFixed(0)} ${widget.currency}',
                      TextStyle(
                        color: rod.toY >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= widget.labels.length) return const SizedBox.shrink();
                      // Показываем подписи только для каждого 5-го дня/месяца
                      if (idx % 5 != 0 && idx != widget.labels.length - 1) return const SizedBox.shrink();
                      return Text(widget.labels[idx], style: const TextStyle(fontSize: 10));
                    },
                    reservedSize: 28,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              barGroups: List.generate(widget.values.length, (i) {
                final v = widget.values[i];
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: v,
                      color: v >= 0 ? Colors.green : Colors.red,
                      width: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
              maxY: widget.values.isNotEmpty ? (widget.values.reduce((a, b) => a > b ? a : b) * 1.2).abs() : 10,
              minY: widget.values.isNotEmpty ? (widget.values.reduce((a, b) => a < b ? a : b) * 1.2).abs() * -1 : -10,
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
          ),
        ),
      ],
    );
  }
} 