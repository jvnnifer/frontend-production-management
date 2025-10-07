import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/controller/AuthController.dart';
import '../../controller/RadioController.dart';

class RadioButton extends StatelessWidget {
  final List<String> options;
  final String? initValue;
  final RadioController controller;

  const RadioButton({
    super.key,
    required this.options,
    required this.controller,
    this.initValue,
  });

  @override
  Widget build(BuildContext context) {
    // Set default value hanya sekali
    if (controller.selected.value.isEmpty) {
      controller.setSelected(initValue ?? options.first);
    }

    return Obx(() => Column(
          children: options.map((option) {
            final isSelected = controller.selected.value == option;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal[50] : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: controller.selected.value,
                activeColor: Colors.teal,
                onChanged: (value) {
                  if (value != null) {
                    controller.setSelected(value);
                    final authController = Get.find<AuthController>();
                    authController.type.value = value;
                  }
                },
              ),
            );
          }).toList(),
        ));
  }
}
