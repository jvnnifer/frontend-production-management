import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/components/TextFieldCreate.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/SidebarController.dart';

class CreateMaterial extends StatelessWidget {
  CreateMaterial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final String? materialId = args['id'];
    final String? materialName = args['materialName'];
    final String? stockQty = args['stockQty'];
    final String? unit = args['unit'];

    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    if (materialId != null) {
      controller.materialName.value = materialName ?? '';
      controller.stockQty.value = stockQty ?? '';
      controller.unit.value = unit ?? '';
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
                      TextFieldCreate(
                        name: "Nama Material",
                        onChanged: (value) =>
                            controller.materialName.value = value,
                        initialValue: controller.materialName.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Jumlah Stok",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Stok",
                        keyboardType: TextInputType.number,
                        onChanged: (value) => controller.stockQty.value = value,
                        initialValue: controller.stockQty.value,
                        width: 150,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Unit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: 'Unit',
                        onChanged: (value) => controller.unit.value = value,
                        initialValue: controller.unit.value,
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
                                    if (materialId == null) {
                                      controller.createMaterial();
                                    } else {
                                      controller.updateMaterial(materialId!);
                                    }
                                  },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(materialId == null
                                    ? "Buat Material"
                                    : "Update Material"),
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
