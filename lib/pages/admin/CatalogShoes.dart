import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../components/CollapsibleSidebar.dart';
import '../../controller/SidebarController.dart';
import 'package:jago_app/controller/AuthController.dart';

class CatalogShoes extends StatelessWidget {
  const CatalogShoes({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();
    controller.loadCatalog();

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
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        sidebar.handleMenuTap("/create");
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
                    Obx(() {
                      final items = controller.catalogItems;
                      if (items.isEmpty) {
                        return const Center(
                          child: Text("Belum ada catalog item."),
                        );
                      }

                      return Column(
                        children: items.map((item) {
                          final title = item['title'] ?? 'Judul tidak ada';
                          final price = item['price'] ?? 0;
                          final formattedPrice =
                              NumberFormat("#,###", "id_ID").format(price);
                          final description =
                              item['description'] ?? 'Deskripsi kosong';

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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (item['attachment'] != null &&
                                          item['attachment']
                                              .toString()
                                              .isNotEmpty)
                                      ? Image.memory(
                                          base64Decode(item['attachment']),
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "lib/images/shoeicon.png",
                                          width: 120,
                                          height: 120,
                                        ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              "Rp $formattedPrice",
                                              style: const TextStyle(
                                                color: Color(0xFF80CBC4),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        /// Description
                                        Text(
                                          description,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                        const SizedBox(height: 12),

                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 243, 185, 52),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                ),
                                                onPressed: () {
                                                  // TODO: tambahin action edit
                                                },
                                                child: const Text(
                                                  "Edit",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 243, 52, 52),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                ),
                                                onPressed: () {
                                                  // TODO: tambahin action delete
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
