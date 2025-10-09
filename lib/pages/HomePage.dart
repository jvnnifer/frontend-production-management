import 'package:flutter/material.dart';
import 'package:jago_app/components/HomeBarChart.dart';
import 'package:jago_app/components/ToggleSwitchTime.dart';
import 'package:jago_app/controller/AuthController.dart';
import '../components/CollapsibleSidebar.dart';
import '../controller/SidebarController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();

    DateTime sysDate = DateTime.now();
    String dateNow = DateFormat('dd-MMM-yyyy').format(sysDate);

    controller.loadMaterialLogSummary();
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
                          if (sidebar.isCollapsed.value)
                            IconButton(
                              icon: const Icon(Icons.menu, color: Colors.black),
                              onPressed: sidebar.toggleSidebar,
                            )
                          else
                            const SizedBox(width: 48),
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
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Informasi Umum',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // bagian card teal
                Obx(
                  () => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF80CBC4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  'Hari ini,',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '$dateNow',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.totalProduksi.value.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Produksi",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                // pembatas
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                // end
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.totalMasuk.value.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Stok Masuk",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                // pembatas
                                Container(
                                  width: 1,
                                  height: 50,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                ),
                                // end
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      controller.totalKeluar.value.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Stok Keluar",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // end card biru
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Menu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Wrap(
                  spacing: 30,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    buildMenuItem(
                      icon: FontAwesomeIcons.boxOpen,
                      label: "Katalog",
                      onTap: () => Get.toNamed('/catalog'),
                    ),
                    buildMenuItem(
                      icon: FontAwesomeIcons.industry,
                      label: "Persiapan Produksi",
                      onTap: () => Get.toNamed('/preparationorder'),
                    ),
                    buildMenuItem(
                      icon: FontAwesomeIcons.cubes,
                      label: "Bahan Baku",
                      onTap: () => Get.toNamed('/rawmaterial'),
                    ),
                    buildMenuItem(
                      icon: FontAwesomeIcons.boxArchive,
                      label: "Material Log",
                      onTap: () => Get.toNamed('/materiallog'),
                    ),
                    buildMenuItem(
                      icon: Icons.shopping_cart,
                      label: "Order",
                      onTap: () => Get.toNamed('/order'),
                    ),
                    buildMenuItem(
                      icon: Icons.admin_panel_settings,
                      label: "Role",
                      onTap: () {},
                    ),
                    buildMenuItem(
                      icon: Icons.rule,
                      label: "Privilege",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 420,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.87),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Hasil Produksi",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              ToggleSwitchTime(),
                            ],
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            height: 220,
                            child: HomeBarChart(),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF80CBC4),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {},
                              child: Text('Lihat Selengkapnya'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
              ))
        ],
      ),
    );
  }
}

Widget buildMenuItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: SizedBox(
      width: 80,
      height: 120,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 202, 246, 241),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 20,
                color: const Color(0xFF80CBC4),
              ),
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
