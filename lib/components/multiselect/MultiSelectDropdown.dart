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
    List<Map<String, dynamic>> matchedInitialValues = [];

    if (title == 'Material') {
      matchedInitialValues = options
          .where((opt) =>
              controller.selectedMaterials.any((sel) => sel['id'] == opt['id']))
          .toList();
    } else if (title == 'Catalog') {
      matchedInitialValues = options
          .where((opt) => controller.selectedCatalogs
              .any((sel) => sel['catalog_id'] == opt['id']))
          .toList();
    }
    return Obx(() {
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
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            searchable: true,
            buttonIcon: const Icon(
              Icons.arrow_drop_down,
            ),
            buttonText: Text(
              "Pilih $title",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
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
                final selected = results
                    .map((mat) => {
                          "id": mat["id"],
                          "name": mat["materialName"],
                          "reqQty": 0,
                        })
                    .toList();
                controller.selectedMaterials.assignAll(selected);
                onChanged(selected);
              } else if (title == 'Catalog') {
                final selected = results
                    .map((cat) => {
                          "catalog_id": cat["id"],
                          "qty": 0,
                          "title": cat["title"],
                        })
                    .toList();
                controller.selectedCatalogs.assignAll(selected);
                onChanged(selected);
              }
            },
          ),
          const SizedBox(height: 10),
          if (title == 'Material')
            ...controller.selectedMaterials.map((mat) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      mat['name'] ?? '',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
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
              );
            }).toList(),
          if (title == 'Catalog')
            ...controller.selectedCatalogs.map((mat) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      mat['title'] ?? '',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
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
                        mat['qty'] = int.tryParse(val) ?? 0;
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
        ],
      );
    });
  }
}
