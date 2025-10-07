import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter/material.dart';

class ToggleSwitchTime extends StatefulWidget {
  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitchTime> {
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 90.0,
      initialLabelIndex: 0,
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: ['Bulanan', 'Tahunan'],
      activeBgColors: [
        [Color(0xFF80CBC4)],
        [Color(0xFF80CBC4)],
      ],
      onToggle: (index) {},
    );
  }
}
