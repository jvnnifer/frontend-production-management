import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/components/TextFieldCreate.dart';
import 'package:jago_app/components/dropdown/SearchableDropdownWidget.dart';
import 'package:jago_app/components/radiobutton/radio_button.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/RadioController.dart';
import 'package:jago_app/controller/SidebarController.dart';

class CreatePreparationOrder extends StatelessWidget {
  CreatePreparationOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    final radioController = RadioController();
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
                        "Order",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SearchableDropdownWidget(
                        label: 'Order',
                        itemsMaterial: controller.orders,
                        itemAsString: (m) => m?['orderNo'] ?? '',
                        baseColor: Color(0xFF80CBC4),
                        onChanged: (value) {},
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
                              options: [
                                "Waiting Material",
                                "Ready to Process",
                                "Scheduled",
                              ],
                              controller: radioController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Note",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextFieldCreate(
                        name: 'Note',
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Production PIC",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SearchableDropdownWidget(
                        label: 'Production PIC',
                        itemsMaterial: controller.usersGudang,
                        itemAsString: (m) => m?['username'] ?? '',
                        baseColor: const Color(0xFF80CBC4),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Approval By",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SearchableDropdownWidget(
                        label: 'Approval PIC',
                        itemsMaterial: controller.usersAdmin,
                        itemAsString: (m) => m?['username'] ?? '',
                        baseColor: const Color(0xFF80CBC4),
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF80CBC4),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Test")),
                            );
                          },
                          child: const Text("Buat Preparation Order"),
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
