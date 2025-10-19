import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/controller/ChartController.dart';

class HomeBarChartWrapper extends StatelessWidget {
  final ChartController controller = Get.put(ChartController());
  final GlobalKey? globalKey;
  final bool scrollable;
  final double fontScale;

  HomeBarChartWrapper({
    this.globalKey,
    this.scrollable = true,
    this.fontScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Obx(() {
        if (controller.monthlyData.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF80CBC4)),
          );
        }

        final Map<int, double> chartData = {};
        for (int i = 1; i <= 12; i++) {
          chartData[i] = controller.monthlyData[i]?.toDouble() ?? 0;
        }

        final maxY = chartData.values.fold<double>(
              0,
              (prev, val) => val > prev ? val : prev,
            ) +
            2;

        final chart = SizedBox(
          width: 12 * 55.0 + 60, // sedikit lebih kecil biar compact
          height: 260 * fontScale, // tinggi proporsional
          child: Padding(
            padding: EdgeInsets.only(
              right: 16 * fontScale,
              left: 24 * fontScale,
              bottom: 22 * fontScale,
              top: 12 * fontScale,
            ),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade400, width: 1),
                    bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize:
                          35 * fontScale, // lebih kecil tapi masih aman
                      getTitlesWidget: (value, meta) => Padding(
                        padding: EdgeInsets.only(right: 4 * fontScale),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28 * fontScale, // cukup buat teks 3 huruf
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
                        if (value.toInt() >= 1 && value.toInt() <= 12) {
                          return Padding(
                            padding: EdgeInsets.only(top: 2 * fontScale),
                            child: Text(
                              months[value.toInt() - 1],
                              style: TextStyle(
                                fontSize: 11 * fontScale,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: List.generate(12, (index) {
                  int month = index + 1;
                  return BarChartGroupData(
                    x: month,
                    barRods: [
                      BarChartRodData(
                        toY: chartData[month]!,
                        color: const Color(0xFF80CBC4),
                        width: 28 * fontScale,
                        borderRadius: BorderRadius.circular(4 * fontScale),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );

        return scrollable
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: chart,
              )
            : chart;
      }),
    );
  }
}
