import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSection {
  final String label;
  final double value;
  final Color color;

  PieChartSection({
    required this.label,
    required this.value,
    required this.color,
  });
}

class PieChartWidget extends StatelessWidget {
  final List<PieChartSection> sections;
  final int? touchedIndex;
  final Function(int?) onSectionTouch;

  const PieChartWidget({
    super.key,
    required this.sections,
    required this.touchedIndex,
    required this.onSectionTouch,
  });

  @override
  Widget build(BuildContext context) {
    final total = sections.fold<double>(0, (s, e) => s + e.value);

    return PieChart(
      PieChartData(
        startDegreeOffset: -90,
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        centerSpaceColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (event, response) {
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.touchedSection == null) {
              onSectionTouch(null);
              return;
            }
            onSectionTouch(response.touchedSection!.touchedSectionIndex);
          },
        ),
        sections: List.generate(sections.length, (i) {
          final sec = sections[i];
          final isTouched = i == touchedIndex;
          final percent = total > 0 ? sec.value / total * 100 : 0.0;
          return PieChartSectionData(
            color: sec.color,
            value: sec.value,
            radius: isTouched ? 70 : 60,
            title: '${percent.toStringAsFixed(2)}%',
            showTitle: true,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          );
        }),
      ),
    );
  }
}
