import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/components/HomeMenuItem.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:Prodify/controller/SidebarController.dart';
import 'SideMenuTile.dart';

class SideMenuBar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback onMenuTap;
  final String selectedRoute;
  final Function(String) onSelected;

  const SideMenuBar({
    super.key,
    required this.isCollapsed,
    required this.onMenuTap,
    required this.selectedRoute,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final SidebarController sidebar = Get.find<SidebarController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (sidebar.selectedRoute.value != Get.currentRoute) {
        sidebar.selectedRoute.value = Get.currentRoute;
      }
    });

    return Container(
      color: const Color(0xFF1C2841),
      padding: const EdgeInsets.only(top: 40),
      child: Obx(() {
        final menus = getMenusByPrivileges(authController.rolePrivileges);

        return Column(
          children: [
            // === PROFILE ===
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(authController.username.value,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(authController.selectedRoleName,
                  style: const TextStyle(color: Colors.white70)),
              onTap: () => sidebar.handleMenuTap("/usersetting"),
            ),
            const Divider(color: Colors.white24),

            // === MENU ===
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: menus
                    .map((menu) => SideMenuTile(
                          menu: menu,
                          isActive: menu.route == selectedRoute,
                          press: () => onSelected(menu.route),
                        ))
                    .toList(),
              ),
            ),

            // === LOGOUT  ===
            Column(
              children: [
                const Divider(color: Colors.white24),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: _handleLogout,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    final AuthController authController = Get.find<AuthController>();
    final SidebarController sidebar = Get.find<SidebarController>();

    Get.dialog(
      AlertDialog(
        title: const Text(
          "Konfirmasi Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Apakah anda yakin ingin keluar dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Batal",
              style: TextStyle(color: Color(0xFF80CBC4)),
            ),
          ),
          TextButton(
            onPressed: () {
              authController.logout();
              sidebar.selectedRoute.value = "/login";
              Get.offAllNamed("/login");
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Color(0xFF80CBC4)),
            ),
          ),
        ],
      ),
    );
  }
}
