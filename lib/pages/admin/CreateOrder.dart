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
  const CreateOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final args = Get.arguments ?? {};
    final String? orderNo = args['orderNo'];
    final String? status = args['status'];

    return GetX<AuthController>(
      init: Get.find<AuthController>(),
      initState: (_) {
        final controller = Get.find<AuthController>();
        final radioController = Get.put(RadioController());

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
          }

          controller.attachment.value = args['attachment'] ?? '';
        } else {
          controller.orderNo.value = '';
          controller.deptStore.value = '';
          controller.notesOrder.value = '';
          controller.status.value = 'Pending';
          controller.deadline.value = DateTime.now();
          controller.deadlineController.text = '';
          controller.selectedCatalogs.clear();
          controller.attachment.value = '';
        }

        ever(radioController.selected, (val) {
          controller.status.value = val;
        });
        if (status != null) {
          radioController.setSelected(status);
        }
      },
      builder: (controller) {
        final radioController = Get.find<RadioController>();

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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Nama Dept. Store"),
                          TextFieldCreate(
                            name: "Nama Dept. Store",
                            onChanged: (val) =>
                                controller.deptStore.value = val,
                            controller: TextEditingController(
                                text: controller.deptStore.value),
                          ),
                          const SizedBox(height: 20),
                          _label("Nomor Order"),
                          TextFieldCreate(
                            name: "Nomor Order",
                            onChanged: (val) => controller.orderNo.value = val,
                            controller: TextEditingController(
                                text: controller.orderNo.value),
                            readOnly: orderNo != null,
                          ),
                          const SizedBox(height: 20),
                          _label("Deadline"),
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
                          const SizedBox(height: 20),
                          _label("Notes"),
                          TextFieldCreate(
                            name: "Notes",
                            onChanged: (val) =>
                                controller.notesOrder.value = val,
                            controller: TextEditingController(
                                text: controller.notesOrder.value),
                          ),
                          const SizedBox(height: 20),
                          _label("Catalog"),
                          const SizedBox(height: 5),
                          MultiSelectDropdown(
                            title: "Catalog",
                            labelKey: "title",
                            options: controller.catalogItems,
                            onChanged: (selected) {
                              controller.selectedCatalogs.assignAll(selected);
                            },
                          ),
                          const SizedBox(height: 20),
                          _label("Status"),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: RadioButton(
                                  options: [
                                    "Confirmed",
                                    "Pending",
                                    "Cancelled"
                                  ],
                                  controller: radioController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _label("Lampiran"),
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
      },
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
}
