import 'package:get/get.dart';
import 'package:Prodify/controller/ChartController.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

class ToggleSwitchTime extends StatelessWidget {
  final ChartController chartController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ToggleSwitch(
          minWidth: 90.0,
          initialLabelIndex: chartController.selectedMode.value,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          labels: ['Bulanan', 'Tahunan'],
          activeBgColors: [
            [Color(0xFF80CBC4)],
            [Color(0xFF80CBC4)],
          ],
          onToggle: (index) {
            if (index != null) {
              chartController.toggleMode(index);
            }
          },
        ));
  }
}
