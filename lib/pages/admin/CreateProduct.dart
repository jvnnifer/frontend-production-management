import 'package:flutter/material.dart';
import 'package:Prodify/components/ImagePickerWidget.dart';
import 'package:Prodify/components/multiselect/MultiSelectDropdown.dart';
import 'package:Prodify/controller/AuthController.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../components/TextFieldCreate.dart';
import '../../controller/SidebarController.dart';
import 'package:get/get.dart';

class CreateProduct extends StatelessWidget {
  const CreateProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final args = Get.arguments ?? {};
    final String? catalogItemId = args['id'];

    return GetX<AuthController>(
      init: Get.find<AuthController>(),
      initState: (_) {
        final controller = Get.find<AuthController>();

        if (catalogItemId != null) {
          controller.loadMaterialsByCatalog(catalogItemId);
          controller.title.value = args['title'] ?? '';
          controller.createdBy.value = args['createdBy'] ?? '';
          controller.description.value = args['description'] ?? '';
          controller.price.value = args['price']?.toString() ?? '';
          controller.attachment.value = args['attachment'] ?? '';

          final materialsArg = args['materials'] ?? [];
          controller.selectedMaterials.assignAll(
            materialsArg.map<Map<String, dynamic>>((m) {
              return {
                "id": m["id"],
                "name": m["name"] ?? m["materialName"] ?? '',
                "reqQty": m["reqQty"] ?? m["qty"] ?? 0,
              };
            }).toList(),
          );
        } else {
          controller.title.value = '';
          controller.description.value = '';
          controller.price.value = '';
          controller.attachment.value = '';
          controller.selectedMaterials.clear();
        }
      },
      builder: (controller) {
        final materials = controller.materials;
        print(controller.selectedMaterials);

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
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  catalogItemId == null
                                      ? 'Tambah Catalog'
                                      : 'Edit Catalog',
                                  style: const TextStyle(
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Nama Produk"),
                          TextFieldCreate(
                            name: "Nama Produk",
                            onChanged: (value) =>
                                controller.title.value = value,
                            initialValue: controller.title.value,
                          ),
                          const SizedBox(height: 20),
                          _label("Deskripsi"),
                          TextFieldCreate(
                            name: "Deskripsi",
                            onChanged: (value) =>
                                controller.description.value = value,
                            initialValue: controller.description.value,
                          ),
                          const SizedBox(height: 20),
                          _label("Harga"),
                          TextFieldCreate(
                            name: "Harga",
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.price.value = value,
                            initialValue: controller.price.value,
                          ),
                          const SizedBox(height: 20),
                          _label("Material"),
                          const SizedBox(height: 5),
                          MultiSelectDropdown(
                            title: "Material",
                            labelKey: "materialName",
                            options: controller.materials,
                            onChanged: (selected) {
                              controller.selectedMaterials.assignAll(selected);
                            },
                          ),
                          const SizedBox(height: 20),
                          _label("Gambar"),
                          ImagePickerWidget(
                            initialImage: controller.attachment.value.isNotEmpty
                                ? controller.attachment.value
                                : null,
                          ),
                          const SizedBox(height: 50),
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
                                    : () async {
                                        if (catalogItemId == null) {
                                          await controller.createCatalogItem();
                                        } else {
                                          await controller
                                              .updateCatalogItem(catalogItemId);
                                        }
                                      },
                                child: controller.isLoading.value
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        catalogItemId == null
                                            ? "Buat Catalog"
                                            : "Update Catalog",
                                      ),
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
      },
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
}
