import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/components/TextFieldCreate.dart';
import 'package:Prodify/controller/AuthController.dart';
import '../components/CollapsibleSidebar.dart';
import '../controller/SidebarController.dart';
import '../components/dropdown/DropdownWidget.dart';

class UserSetting extends StatelessWidget {
  UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebar = Get.find();
    final controller = Get.find<AuthController>();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black54,
                    child: Icon(CupertinoIcons.person, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Username",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: TextFieldCreate(
                            name: 'Username',
                            onChanged: (value) =>
                                controller.username.value = value,
                            initialValue: controller.username.value,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: TextFieldCreate(
                            name: 'Password',
                            onChanged: (value) =>
                                controller.password.value = value,
                            initialValue: controller.password.value,
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Role",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 5),
                        Obx(() {
                          final roleId = controller.selectedRoleId.value;

                          // Kalau role = ROLE003 (owner), tampilkan teks biasa
                          if (roleId == 'ROLE003') {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.teal.shade400),
                              ),
                              child: Text(
                                controller.selectedRoleName,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            );
                          }

                          return DropdownWidget(
                            label: "",
                            items: controller.roles
                                .map((role) => role['roleName'] as String)
                                .toList(),
                            initialValue:
                                controller.selectedRoleId.value.isEmpty
                                    ? null
                                    : controller.roles.firstWhere((r) =>
                                        r['id'] ==
                                        controller
                                            .selectedRoleId.value)['roleName'],
                            onChanged: (value) {
                              if (value != null) {
                                final selected = controller.roles
                                    .firstWhere((r) => r['roleName'] == value);
                                controller.selectedRoleId.value =
                                    selected['id'];
                              }
                            },
                          );
                        }),
                        SizedBox(
                          height: 50,
                        ),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF80CBC4),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      controller.updateUser();
                                    },
                              child: controller.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text("Ganti Data Diri"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
