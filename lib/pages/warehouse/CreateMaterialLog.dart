import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/components/TextFieldCreate.dart';
import 'package:jago_app/components/dropdown/SearchableDropdownWidget.dart';
import 'package:jago_app/components/radiobutton/radio_button.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/RadioController.dart';
import 'package:jago_app/controller/SidebarController.dart';

class CreateMaterialLog extends StatelessWidget {
  CreateMaterialLog({super.key});

  final SidebarController sidebar = Get.find();
  final radioController = Get.put(RadioController());
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    ever(radioController.selected, (val) {
      controller.type.value = val;
    });

    final args = Get.arguments ?? {};
    final String? note = args['notes'];
    final String? type = args['type'];
    final String? qty = args['qty'];

    if (type != null) {
      controller.note.value = note ?? '';
      controller.type.value = type;
      controller.qty.value = qty ?? '';
      radioController.setSelected(type);
    }
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 10, top: 30),
                      child: Row(
                        children: [
                          sidebar.isCollapsed.value
                              ? IconButton(
                                  icon: const Icon(Icons.menu,
                                      color: Colors.black),
                                  onPressed: sidebar.toggleSidebar,
                                )
                              : const SizedBox(width: 48),
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Produksi Internal',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama Material",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SearchableDropdownWidget(
                        label: 'Material',
                        itemsMaterial: controller.materials,
                        itemAsString: (m) => m?['materialName'] ?? '',
                        baseColor: Color(0xFF80CBC4),
                        onChanged: (value) {
                          controller.selectedMaterialForLog.value = value;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Notes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Notes",
                        onChanged: (value) => controller.note.value = value,
                        initialValue: controller.note.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Jumlah",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Jumlah",
                        keyboardType: TextInputType.number,
                        width: 150,
                        onChanged: (value) => controller.qty.value = value,
                        initialValue: controller.qty.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Tipe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RadioButton(
                              options: ["Masuk", "Keluar"],
                              controller: radioController,
                              initValue: "Masuk",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Obx(
                        () => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF80CBC4),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (controller
                                            .selectedMaterialForLog.value !=
                                        null) {
                                      controller.createMaterialLog();
                                    } else {}
                                  },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    controller.selectedMaterialForLog.value ==
                                            null
                                        ? "Buat Catatan Material"
                                        : "Update Catatan Material"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => CollapsibleSidebar(
                isCollapsed: sidebar.isCollapsed.value,
                toggleSidebar: sidebar.toggleSidebar,
                selectedRoute: sidebar.selectedRoute.value,
                onSelected: sidebar.handleMenuTap,
              )),
        ],
      ),
    );
  }
}
