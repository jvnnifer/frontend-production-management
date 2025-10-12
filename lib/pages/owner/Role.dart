import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/SidebarController.dart';

class Role extends StatelessWidget {
  const Role({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    final SidebarController sidebar = Get.find();

    if (controller.roles.isEmpty) {
      controller.loadRoles();
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
                          'Daftar Role',
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

                // ===== List Roles =====
                Obx(() {
                  if (controller.roles.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: controller.roles.map((role) {
                      final roleName =
                          role['roleName'] ?? role['name'] ?? 'Tidak diketahui';
                      final roleId = role['id'] ?? '';

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
                          subtitle: Text("ID: $roleId"),
                          onTap: () {
                            // bisa navigasi ke detail role
                          },
                        ),
                      );
                    }).toList(),
                  );
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
