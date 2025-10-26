import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/controller/ChartController.dart';

class HomeBarChart extends StatelessWidget {
  final ChartController controller = Get.put(ChartController());

  HomeBarChart({super.key});
  double safeMaxY(Iterable<double> values) {
    if (values.isEmpty) return 0;
    final nonZero = values.where((v) => v.isFinite && v >= 0);
    if (nonZero.isEmpty) return 0;
    return nonZero.reduce((a, b) => a > b ? a : b) + 2;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF80CBC4)),
        );
      }

      if (controller.selectedMode.value == 0) {
        // === BULANAN ===
        final Map<int, double> monthlyData = {};
        for (int i = 1; i <= 12; i++) {
          monthlyData[i] = controller.monthlyData[i]?.toDouble() ?? 0;
        }

        final maxY = safeMaxY(monthlyData.values);

        return SizedBox(
          height: 220,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 12 * 60.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec'
                          ];
                          if (value >= 1 && value <= 12) {
                            return Text(months[value.toInt() - 1]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(12, (i) {
                    final val = monthlyData[i + 1] ?? 0;
                    return BarChartGroupData(
                      x: i + 1,
                      barRods: [
                        BarChartRodData(
                          toY: val,
                          color: const Color(0xFF80CBC4),
                          width: 30,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      } else {
        // === TAHUNAN ===
        final Map<int, double> yearlyData =
            controller.yearlyData.map((k, v) => MapEntry(k, v.toDouble()));

        if (yearlyData.isEmpty) {
          return const Center(child: Text('There is no yearly data.'));
        }

        final currentYear = DateTime.now().year;
        final startYear = currentYear - 4;
        final years = List.generate(5, (i) => startYear + i);

        final sortedYears = years..sort();
        final displayData = {
          for (var year in sortedYears) year: yearlyData[year] ?? 0.0,
        };

        final maxY = safeMaxY(displayData.values);
        return SizedBox(
          height: 220,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: displayData.length * 80.0,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int idx = value.toInt();
                          if (idx >= 0 && idx < displayData.keys.length) {
                            final year = displayData.keys.elementAt(idx);
                            return Text('$year');
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(displayData.length, (i) {
                    final year = displayData.keys.elementAt(i);
                    final val = displayData[year] ?? 0;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: val,
                          color: const Color(0xFF80CBC4),
                          width: 40,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      }
    });
  }
}
