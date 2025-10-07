import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/SidebarController.dart';
import 'Assets.dart';
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
      padding: const EdgeInsets.only(top: 20),
      color: const Color(0xFF1C2841),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile
            Obx(
              () => ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(CupertinoIcons.person, color: Colors.white),
                ),
                title: Text(authController.username.value,
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(authController.selectedRoleName,
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  final sidebar = Get.find<SidebarController>();
                  sidebar.handleMenuTap("/usersetting");
                },
              ),
            ),

            // === UTAMA ===
            _buildSectionTitle("UTAMA"),
            ...sideMenus.map((menu) => SideMenuTile(
                  menu: menu,
                  isActive: menu.route == selectedRoute,
                  press: () => onSelected(menu.route),
                )),

            // === DATA ADMIN ===
            _buildSectionTitle("DATA ADMIN"),
            ...sideMenusAdmin.map((menu) => SideMenuTile(
                  menu: menu,
                  isActive: menu.route == selectedRoute,
                  press: () => onSelected(menu.route),
                )),

            // === DATA GUDANG ===
            _buildSectionTitle("DATA GUDANG"),
            ...sideMenusGudang.map((menu) => SideMenuTile(
                  menu: menu,
                  isActive: menu.route == selectedRoute,
                  press: () => onSelected(menu.route),
                )),

            // === HAK AKSES ===
            _buildSectionTitle("HAK AKSES"),
            ...sideMenus3.map((menu) => SideMenuTile(
                  menu: menu,
                  isActive: menu.route == selectedRoute,
                  press: () => onSelected(menu.route),
                )),
          ],
        ),
      ),
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
}
