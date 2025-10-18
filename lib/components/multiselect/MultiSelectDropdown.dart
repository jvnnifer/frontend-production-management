import 'package:flutter/material.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:get/get.dart';

class MultiSelectDropdown extends StatelessWidget {
  final AuthController controller = Get.find();
  final String title;
  final String labelKey;
  final List<Map<String, dynamic>> options;
  final void Function(List<Map<String, dynamic>>) onChanged;

  MultiSelectDropdown({
    super.key,
    required this.title,
    required this.labelKey,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Map<String, dynamic>> matchedInitialValues = [];

      if (title == 'Material') {
        matchedInitialValues = options
            .where((opt) => controller.selectedMaterials
                .any((sel) => sel['id'] == opt['id']))
            .toList();
      } else if (title == 'Catalog') {
        matchedInitialValues = options
            .where((opt) => controller.selectedCatalogs.any((sel) =>
                sel['catalogId'] == opt['id'] || sel['id'] == opt['id']))
            .toList();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MultiSelectDialogField<Map<String, dynamic>>(
            items: options
                .map((m) =>
                    MultiSelectItem<Map<String, dynamic>>(m, m[labelKey] ?? ''))
                .toList(),
            initialValue: matchedInitialValues,
            title: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            searchable: true,
            buttonIcon: const Icon(Icons.arrow_drop_down),
            buttonText: Text(
              "Pilih $title",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            selectedColor: const Color(0xFF80CBC4),
            chipDisplay: MultiSelectChipDisplay(
              chipColor: const Color(0xFF80CBC4),
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF80CBC4),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            onConfirm: (results) {
              if (title == 'Material') {
                final selected = results.map((mat) {
                  final existing = controller.selectedMaterials
                      .firstWhereOrNull((sel) => sel['id'] == mat['id']);
                  return {
                    "id": mat["id"],
                    "name": mat["materialName"],
                    "reqQty": existing?['reqQty'] ?? 0,
                    "unit": mat["unit"],
                  };
                }).toList();

                controller.selectedMaterials.assignAll(selected);
                onChanged(selected);
              } else if (title == 'Catalog') {
                final selected = results.map((cat) {
                  final existing = controller.selectedCatalogs.firstWhereOrNull(
                    (sel) =>
                        sel['catalogId'] == cat['id'] || sel['id'] == cat['id'],
                  );

                  return {
                    "catalogId": cat["id"] ?? existing?['catalogId'],
                    "title": cat["title"],
                    "qty": existing?['qty'] ?? cat['qty'] ?? 0,
                  };
                }).toList();

                controller.selectedCatalogs.assignAll(selected);
                onChanged(selected);
              }
            },
          ),
          const SizedBox(height: 10),
          if (title == 'Material')
            ...controller.selectedMaterials.map((mat) {
              final qtyController = TextEditingController(
                text: mat['reqQty']?.toString() ?? '',
              );
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${mat['name'] ?? ''}",
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: qtyController,
                        decoration: const InputDecoration(
                          hintText: "Jumlah",
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFF80CBC4), width: 2),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF80CBC4)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          mat['reqQty'] = int.tryParse(val) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          if (title == 'Catalog')
            ...controller.selectedCatalogs.map((cat) {
              final qtyController = TextEditingController(
                text: cat['qty']?.toString() ?? '',
              );
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cat['title'] ?? '',
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: qtyController,
                        decoration: const InputDecoration(
                          hintText: "Jumlah",
                          isDense: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xFF80CBC4), width: 2),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF80CBC4)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          cat['qty'] = int.tryParse(val) ?? 0;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      );
    });
  }
}
