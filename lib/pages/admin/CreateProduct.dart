import 'package:flutter/material.dart';
import 'package:jago_app/components/ImagePickerWidget.dart';
import 'package:jago_app/components/multiselect/MultiSelectDropdown.dart';
import 'package:jago_app/controller/AuthController.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../components/TextFieldCreate.dart';
import '../../controller/SidebarController.dart';
import 'package:get/get.dart';

class CreateProduct extends StatelessWidget {
  const CreateProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    final args = Get.arguments ?? {};
    final String? catalogItemId = args['id'];
    final String? title = args['title'];
    final String? createdBy = args['createdBy'];
    final String? description = args['description'];
    final String? price = args['price'].toString();
    final String? attachment = args['attachment'];
    final List<dynamic>? selectedMaterialsArg = args['materials'];

    if (catalogItemId != null) {
      controller.createdBy.value = createdBy ?? '';
      controller.title.value = title ?? '';
      controller.description.value = description ?? '';
      controller.price.value = price ?? '';
      controller.attachment.value = attachment ?? '';

      if (selectedMaterialsArg != null) {
        controller.selectedMaterials.assignAll(selectedMaterialsArg
            .map((e) => Map<String, dynamic>.from(e))
            .toList());
      }
    }

    final materials = controller.materials;

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
                        "Nama Produk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Nama Produk",
                        onChanged: (value) => controller.title.value = value,
                        initialValue: controller.title.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Deskripsi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Deskripsi",
                        onChanged: (value) =>
                            controller.description.value = value,
                        initialValue: controller.description.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Harga",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: 'Harga',
                        keyboardType: TextInputType.number,
                        onChanged: (value) => controller.price.value = value,
                        initialValue: controller.price.value,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Material",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      MultiSelectDropdown(
                        title: "Material",
                        options: materials,
                        labelKey: "materialName",
                        onChanged: (selected) {
                          controller.selectedMaterials.assignAll(selected);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Gambar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ImagePickerWidget(
                        initialImage: controller.attachment.value.isNotEmpty
                            ? controller.attachment.value
                            : null,
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
                                    if (catalogItemId == null) {
                                      controller.createCatalogItem();
                                    } else {
                                      controller
                                          .updateCatalogItem(catalogItemId);
                                    }
                                  },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(catalogItemId == null
                                    ? "Buat Catalog"
                                    : "Update Catalog"),
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
