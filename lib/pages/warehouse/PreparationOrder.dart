import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Prodify/components/CollapsibleSidebar.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:Prodify/controller/SidebarController.dart';

class PreparationOrder extends StatelessWidget {
  const PreparationOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    controller.loadPreparationOrders();
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
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          sidebar.handleMenuTap("/createPrepOrder");
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "+ Tambah Item",
                            style: TextStyle(
                              color: Color(0xFF80CBC4),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // LIST CARD
                      Obx(() {
                        final prepOrders = controller.prepOrders;

                        if (prepOrders.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                "Belum ada Preparation Order",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: prepOrders.map((order) {
                            final color = order["status"] == "Waiting Material"
                                ? Colors.orange[100]
                                : order["status"] == "Ready to Process"
                                    ? Colors.green[100]
                                    : Colors.blue[100];

                            final textColor =
                                order["status"] == "Waiting Material"
                                    ? Colors.orange[700]
                                    : order["status"] == "Ready to Process"
                                        ? Colors.green[700]
                                        : Colors.blue[700];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // HEADER STATUS
                                  Container(
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          order["orders"]["orderNo"] ?? "-",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          order["status"],
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // BODY CARD
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order["note"] ?? "-",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Prod. PIC: ${order['productionPic']}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700),
                                            ),
                                            Text(
                                              "Approval: ${order['approvalPic']}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        if (controller.selectedRoleId ==
                                                "ROLE001" &&
                                            (order["status"] ==
                                                    "Waiting Material" ||
                                                order["status"] == "Scheduled"))
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF80CBC4),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                              ),
                                              onPressed: () async {
                                                controller
                                                    .approvePreparationOrder(
                                                        order["id"]);
                                              },
                                              child: const Text(
                                                "Approve",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      }),

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
