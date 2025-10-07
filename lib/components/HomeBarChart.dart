import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeBarChart extends StatelessWidget {
  const HomeBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Sen');
                  case 1:
                    return const Text('Sel');
                  case 2:
                    return const Text('Rab');
                  case 3:
                    return const Text('Kam');
                  case 4:
                    return const Text('Jum');
                  default:
                    return const Text('');
                }
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 5, color: Color(0xFF80CBC4)),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 7, color: Color(0xFF80CBC4)),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 6, color: Color(0xFF80CBC4)),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: 8, color: Color(0xFF80CBC4)),
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(toY: 3, color: Color(0xFF80CBC4)),
          ]),
        ],
      ),
    );
  }
}
