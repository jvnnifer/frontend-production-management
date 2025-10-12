import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/api_services/ApiService.dart';
import 'package:jago_app/components/CollapsibleSidebar.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/controller/SidebarController.dart';

class Privileges extends StatefulWidget {
  const Privileges({super.key});

  @override
  State<Privileges> createState() => _PrivilegesState();
}

class _PrivilegesState extends State<Privileges> {
  final SidebarController sidebar = Get.find();
  final controller = Get.find<AuthController>();
  Map<String, bool> checkedPrivileges = {};

  String selectedRoleId = '';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    try {
      await controller.loadAllPrivileges();

      // Ambil unique privileges berdasarkan privilege_id
      final seenIds = <String>{};
      final uniqueAllPrivileges = <Map<String, dynamic>>[];

      for (var p in controller.allPrivileges) {
        final id = p['pk']?['privilege_id']?.toString();
        if (id != null && !seenIds.contains(id)) {
          seenIds.add(id);
          uniqueAllPrivileges.add(p);
        }
      }
      controller.allPrivileges.assignAll(uniqueAllPrivileges);

      // Ambil role pertama
      if (controller.roles.isNotEmpty) {
        selectedRoleId = controller.roles.first['id'].toString();

        await controller.loadPrivilegesByRole(selectedRoleId);

        final seenRoleIds = <String>{};
        final uniqueRolePrivileges = <Map<String, dynamic>>[];

        for (var rp in controller.privileges) {
          final id = rp['pk']?['privilege_id']?.toString();
          if (id != null && !seenRoleIds.contains(id)) {
            seenRoleIds.add(id);
            uniqueRolePrivileges.add(rp);
          }
        }
        controller.privileges.assignAll(uniqueRolePrivileges);

        _syncCheckedPrivileges();
        setState(() {});
      }
    } catch (e) {
      print("Error init data: $e");
    }
  }

  void _syncCheckedPrivileges() {
    checkedPrivileges.clear();

    final rolePrivilegeIds = controller.privileges
        .map((rp) => rp['pk']['privilege_id'].toString())
        .toSet();

    for (var p in controller.allPrivileges) {
      checkedPrivileges[p['pk']['privilege_id'].toString()] =
          rolePrivilegeIds.contains(p['pk']['privilege_id'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
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
                                icon:
                                    const Icon(Icons.menu, color: Colors.black),
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

                  // ===== Dropdown Role =====
                  Row(
                    children: [
                      SizedBox(width: 10),
                      const Text(
                        "Hak Akses ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      Obx(() {
                        return DropdownButton<String>(
                          value: selectedRoleId.isEmpty ? null : selectedRoleId,
                          icon: const Icon(Icons.arrow_drop_down),
                          underline: Container(
                            height: 2,
                            color: const Color(0xFF80CBC4),
                          ),
                          items: controller.roles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role['id'].toString(),
                              child:
                                  Text(role['roleName'] ?? role['name'] ?? ''),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            setState(() {
                              selectedRoleId = value; // ubah state lokal
                            });
                            await controller.loadPrivilegesByRole(value);
                            _syncCheckedPrivileges();
                          },
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ===== List Privileges =====
                  Obx(() {
                    final allPrivileges = controller.allPrivileges;
                    final rolePrivileges = controller.privileges;

                    if (allPrivileges.isEmpty) {
                      return const Text("Tidak ada data privilege.");
                    }

                    return Column(
                      children: allPrivileges.map((p) {
                        bool isChecked = rolePrivileges.any(
                          (rp) =>
                              rp['pk']['privilege_id'] ==
                              p['pk']['privilege_id'],
                        );

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              p['privilegeName'] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            subtitle: Text(p['privilegeCode'] ?? ''),
                            value: checkedPrivileges[p['pk']['privilege_id']] ??
                                false,
                            onChanged: (val) {
                              setState(() {
                                checkedPrivileges[p['pk']['privilege_id']] =
                                    val ?? false;
                              });
                            },
                            activeColor: Color(0xFF80CBC4),
                            checkColor: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
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

      // ===== Save Button =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          List<String> selectedPrivileges = checkedPrivileges.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .toList();

          try {
            await ApiService()
                .saveRolePrivileges(selectedRoleId, selectedPrivileges);

            Get.snackbar(
              "Success",
              "Privileges untuk role disimpan",
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );

            sidebar.selectedRoute.value = "/home";
          } catch (e) {
            Get.snackbar(
              "Error",
              "Gagal menyimpan privileges",
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
            );
          }
        },
        icon: const Icon(Icons.save, color: Colors.white),
        label: const Text(
          "Simpan Perubahan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF80CBC4),
      ),
    );
  }
}
