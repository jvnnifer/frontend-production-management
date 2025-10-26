import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Prodify/components/CollapsibleSidebar.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:Prodify/controller/SidebarController.dart';

class RawMaterials extends StatelessWidget {
  const RawMaterials({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    controller.loadMaterials();
    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            final materials = controller.materials;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            sidebar.handleMenuTap("/creatematerial");
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

                        /// List Material
                        const SizedBox(height: 10),
                        ...materials.map((mat) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
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
                              border: Border.all(
                                  color: Colors.grey.shade200, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Nama Material
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          mat['materialName'] ?? 'Material',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  /// Stok + Unit
                                  Row(
                                    children: [
                                      Text(
                                        "Stok: ${mat['stockQty'] ?? '-'}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        "Satuan: ${mat['unit'] ?? '-'}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  /// Tombol edit delete
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 243, 185, 52),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            '/creatematerial',
                                            arguments: {
                                              'id': mat['id'],
                                              'materialName':
                                                  mat['materialName'],
                                              'stockQty':
                                                  mat['stockQty'].toString(),
                                              'unit': mat['unit'],
                                            },
                                          );
                                        },
                                        child: const Text("Edit",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 243, 52, 52),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Confirm Delete",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: Text(
                                                    "Yakin untuk menghapus?"),
                                                actions: [
                                                  TextButton(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF80CBC4),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF80CBC4),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      controller
                                                          .deleteMaterials(
                                                              mat['id']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text("Delete",
                                            style: TextStyle(fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
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
