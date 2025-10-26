import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Prodify/components/CollapsibleSidebar.dart';
import 'package:Prodify/controller/SidebarController.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:intl/intl.dart';

class MaterialLog extends StatelessWidget {
  MaterialLog({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();
    controller.getAllMaterialLogs();

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
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          sidebar.handleMenuTap("/createmateriallog");
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
                      const SizedBox(height: 20),

                      // === LIST MATERIAL LOG ===
                      Obx(() {
                        final logs = controller.materialLogs;
                        if (logs.isEmpty) {
                          return const Center(
                            child: Text("Belum ada log material."),
                          );
                        }

                        return Column(
                          children: logs.map((log) {
                            final type = log['type']?.toString() ?? '';
                            final materialName =
                                log['material']?['materialName'] ?? 'Unknown';
                            final qty = log['qty'] ?? 0;
                            final rawDate = log['createdDate'];
                            String date = '';
                            if (rawDate != null) {
                              try {
                                final parsedDate =
                                    DateTime.parse(rawDate.toString());
                                date =
                                    DateFormat('dd-MM-yyyy').format(parsedDate);
                              } catch (e) {
                                date = rawDate.toString();
                              }
                            }

                            final isMasuk = type.toLowerCase() == "masuk";

                            return Card(
                              color:
                                  isMasuk ? Colors.green[50] : Colors.red[50],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(
                                  isMasuk
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: isMasuk ? Colors.green : Colors.red,
                                ),
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isMasuk
                                              ? Colors.green[100]
                                              : Colors.red[100],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          date,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isMasuk
                                                ? Colors.green[900]
                                                : Colors.red[900],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        materialName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                                subtitle: Text(isMasuk
                                    ? "Pemasukan: $qty"
                                    : "Pengeluaran: $qty"),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${isMasuk ? "+" : "-"}$qty",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            isMasuk ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
