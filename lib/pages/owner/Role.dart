import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/components/CollapsibleSidebar.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:Prodify/controller/SidebarController.dart';

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final SidebarController sidebar = Get.find();
    final RxBool isAddingRole = false.obs;
    final TextEditingController roleNameController = TextEditingController();

    if (controller.rolesAll.isEmpty) {
      controller.loadRolesAll();
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Header =====
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Obx(() => sidebar.isCollapsed.value
                          ? IconButton(
                              icon: const Icon(Icons.menu, color: Colors.black),
                              onPressed: sidebar.toggleSidebar,
                            )
                          : const SizedBox(width: 48)),
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

                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          isAddingRole.value = true;
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
                    ],
                  ),
                ),

                // ===== List Roles =====
                Obx(() {
                  if (controller.rolesAll.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(children: [
                    if (isAddingRole.value)
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.add, color: Colors.teal),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: roleNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Masukkan nama role',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.redAccent),
                                onPressed: () {
                                  isAddingRole.value = false;
                                  roleNameController.clear();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () {
                                  if (roleNameController.text.isNotEmpty) {
                                    controller.roleName.value =
                                        roleNameController.text;
                                    controller.createRole();
                                    roleNameController.clear();
                                    isAddingRole.value = false;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ...controller.rolesAll.map((role) {
                      final roleName =
                          role['roleName'] ?? role['name'] ?? 'Tidak diketahui';
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.admin_panel_settings),
                          title: Text(
                            roleName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          onTap: () {},
                        ),
                      );
                    }).toList(),
                  ]);
                }),
              ],
            ),
          ),

          // ===== Sidebar =====
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
