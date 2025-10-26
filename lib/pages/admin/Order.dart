import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/controller/AuthController.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../controller/SidebarController.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();
    controller.loadOrders();

    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => Container(
                    height: 100,
                    padding: const EdgeInsets.only(left: 10, top: 30),
                    child: Row(
                      children: [
                        sidebar.isCollapsed.value
                            ? IconButton(
                                icon:
                                    const Icon(Icons.menu, color: Colors.black),
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
                        sidebar.handleMenuTap("/createorder");
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
                    Obx(() {
                      final orders = controller.orders;
                      if (orders.isEmpty) {
                        return const Center(
                          child: Text("Belum ada order."),
                        );
                      }

                      return Column(
                        children: orders.map((order) {
                          final orderNo = order['orderNo'] ?? '-';
                          final deptStore = order['deptStore'] ?? '-';
                          final status = order['status'] ?? '-';
                          final notes = order['notes'] ?? '-';

                          return Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderNo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: status == 'Pending'
                                            ? Colors.orange.withOpacity(0.1)
                                            : status == 'On Progress'
                                                ? Colors.green.withOpacity(0.1)
                                                : status == 'Confirmed'
                                                    ? Colors.blue
                                                        .withOpacity(0.1)
                                                    : Colors.red
                                                        .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        status,
                                        style: TextStyle(
                                          color: status == 'Pending'
                                              ? Colors.orange
                                              : status == 'On Progress'
                                                  ? Colors.green
                                                  : status == 'Confirmed'
                                                      ? Colors.blue
                                                      : Colors.red,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Department Store:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "$deptStore",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF80CBC4),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    onPressed: () {
                                      Get.toNamed('/orderdetail', arguments: {
                                        ...order,
                                        'orderNo': orderNo,
                                      });
                                    },
                                    child: const Text(
                                      "Lihat Detail",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }),
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
    ));
  }
}
