import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Prodify/controller/AuthController.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../controller/SidebarController.dart';

class OrderDetail extends StatelessWidget {
  OrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();

    final args = Get.arguments ?? {};
    final String? orderNo = args['orderNo'];
    final controller = Get.find<AuthController>();
    if (orderNo != null) {
      controller.fetchOrderDetail(orderNo);
    }

    String _formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return '-';
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('dd-MM-yyyy').format(date);
      } catch (e) {
        return dateStr;
      }
    }

    Color _getStatusColor(String? status) {
      if (status?.toLowerCase() == 'pending') {
        return Colors.orange;
      } else if (status?.toLowerCase() == 'on progress') {
        return Colors.green;
      } else if (status?.toLowerCase() == 'confirmed') {
        return Colors.blue;
      } else {
        return Colors.red;
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Obx(() {
              final order = controller.orderDetail;

              if (order.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: CircularProgressIndicator(color: Color(0xFF80CBC4)),
                  ),
                );
              }

              return Column(
                children: [
                  Container(
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
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    padding:
                        const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                    child: Column(
                      children: [
                        Container(
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
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order['orderNo'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag,
                                      color: Colors.black45, size: 20),
                                  const SizedBox(width: 5),
                                  Text(
                                    order['deptStore'] ?? '-',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order['status'])
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order['status'] ?? '-',
                                      style: TextStyle(
                                        color: _getStatusColor(order['status']),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Divider(
                                color: Colors.grey[200],
                                thickness: 1,
                                indent: 4,
                                endIndent: 4,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.date_range,
                                      color: Colors.black45, size: 20),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Deadline",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        _formatDate(order['deadline']),
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info,
                                      color: Colors.black45, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Notes",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          order['notes'] ?? '-',
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.inventory,
                                      color: Colors.black45, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Catalog Items",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        if (order['catalogs'] != null)
                                          ...order['catalogs']
                                              .map<Widget>((item) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Text(
                                                "${item['title']} : ${item['qty']}",
                                                style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            );
                                          }).toList()
                                        else
                                          const Text(
                                            "-",
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w400),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Icon(Icons.attach_file,
                                        color: Colors.black45, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (order['attachment'] != null &&
                                          (order['attachment'] is String &&
                                              order['attachment']
                                                  .toString()
                                                  .isNotEmpty))
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 20),
                                            const Text(
                                              "Attachment",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Builder(
                                              builder: (context) {
                                                try {
                                                  final bytes = base64Decode(
                                                      order['attachment']);
                                                  final screenWidth =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;

                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: SizedBox(
                                                      width: screenWidth * 0.5,
                                                      child: Image.memory(
                                                        bytes,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Text(
                                                            "Gagal memuat gambar",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  return const Text(
                                                    "Format attachment tidak valid",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
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
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 243, 185, 52),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                    ),
                                    onPressed: controller.orderDetail.isEmpty
                                        ? null
                                        : () {
                                            final order =
                                                controller.orderDetail;
                                            Get.toNamed('/createorder',
                                                arguments: {
                                                  'orderNo':
                                                      order['orderNo'] ?? '',
                                                  'deptStore':
                                                      order['deptStore'] ?? '',
                                                  'notes': order['notes'] ?? '',
                                                  'status': order['status'] ??
                                                      'Pending',
                                                  'deadline': order[
                                                          'deadline'] ??
                                                      DateTime.now()
                                                          .toIso8601String(),
                                                  'catalogs':
                                                      order['catalogs'] ?? [],
                                                  'attachment':
                                                      order['attachment'] ?? '',
                                                });
                                          },
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
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
                                      Get.back();
                                    },
                                    child: const Text(
                                      "Kembali",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
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
