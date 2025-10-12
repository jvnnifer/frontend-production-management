import 'dart:typed_data';
import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:jago_app/controller/ChartController.dart';

class HomeBarChartWrapper extends StatelessWidget {
  final ChartController controller = Get.put(ChartController());
  final GlobalKey? globalKey;

  HomeBarChartWrapper({this.globalKey});

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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 12 * 60.0 + 40,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 32),
                    ),
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
                          if (value.toInt() >= 1 && value.toInt() <= 12) {
                            return Text(
                              months[value.toInt() - 1],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<Uint8List?> captureChart() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final boundary = globalKey?.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing chart: $e");
      return null;
    }
  }
}
