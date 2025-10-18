import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jago_app/components/ImagePickerWidget.dart';
import 'package:jago_app/components/multiselect/MultiSelectDropdown.dart';
import 'package:jago_app/components/radiobutton/radio_button.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/RadioController.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../components/TextFieldCreate.dart';
import '../../controller/SidebarController.dart';
import 'package:get/get.dart';

class CreateOrder extends StatelessWidget {
  CreateOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();
    final radioController = RadioController();

    final args = Get.arguments ?? {};
    final String? orderNo = args['orderNo'];
    final String? status = args['status'];

    if (orderNo != null) {
      controller.orderNo.value = orderNo;
      controller.deptStore.value = args['deptStore'] ?? '';
      controller.notesOrder.value = args['notes'] ?? '';
      controller.status.value = args['status'] ?? 'Pending';
      if (args['deadline'] != null) {
        final apiDate = DateTime.tryParse(args['deadline']);
        controller.deadline.value = apiDate ?? DateTime.now();
        controller.deadlineController.text =
            apiDate != null ? DateFormat('dd-MM-yyyy').format(apiDate) : '';
      } else {
        controller.deadline.value = DateTime.now();
        controller.deadlineController.text = '';
      }
      if (args['catalogs'] != null) {
        controller.selectedCatalogs.assignAll(
          (args['catalogs'] as List<dynamic>).map((e) {
            return {
              "catalogId": e["catalogId"],
              "title": e["title"] ?? '',
              "qty": e["qty"] ?? 0,
            };
          }).toList(),
        );

        print("Loaded catalogs from args: ${controller.selectedCatalogs}");
      }

      controller.attachment.value = args['attachment'] ?? '';
    }

    ever(radioController.selected, (val) {
      controller.status.value = val;
    });
    if (status != null) {
      radioController.setSelected(status);
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
                        "Nama Dept. Store",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Nama Dept. Store",
                        onChanged: (val) => controller.deptStore.value = val,
                        controller: TextEditingController(
                            text: controller.deptStore.value),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Nomor Order",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Nomor Order",
                        onChanged: (val) => controller.orderNo.value = val,
                        controller: TextEditingController(
                            text: controller.orderNo.value),
                        readOnly: orderNo != null,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Deadline",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: 'Deadline',
                        isDate: true,
                        onChanged: (val) {
                          if (val != null && val is DateTime) {
                            controller.deadline.value = val;
                          }
                        },
                        controller: controller.deadlineController,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Notes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: "Notes",
                        onChanged: (val) => controller.notesOrder.value = val,
                        controller: TextEditingController(
                            text: controller.notesOrder.value),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Catalog",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      MultiSelectDropdown(
                        title: "Catalog",
                        labelKey: "title",
                        options: controller.catalogItems,
                        onChanged: (selected) {
                          controller.selectedCatalogs.assignAll(selected);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RadioButton(
                              options: ["Pending", "Cancelled"],
                              controller: radioController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Lampiran",
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
                                    if (orderNo != null) {
                                      controller.updateOrder(orderNo);
                                    } else {
                                      controller.createOrder();
                                    }
                                  },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(orderNo != null
                                    ? "Update Order"
                                    : "Buat Order"),
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
