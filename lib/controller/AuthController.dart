import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/api_services/ApiService.dart';
import 'package:jago_app/controller/RadioController.dart';
import 'package:jago_app/pages/HomePage.dart';
import 'package:jago_app/pages/Login.dart';
import 'package:jago_app/pages/admin/CatalogShoes.dart';
import 'package:jago_app/pages/admin/Order.dart';
import 'package:jago_app/pages/warehouse/PreparationOrder.dart';
import 'package:jago_app/pages/warehouse/RawMaterials.dart';
import 'dart:io';
import 'dart:convert';

class AuthController extends GetxController {
  final ApiService apiService = ApiService();
  final radioController = Get.put(RadioController());
  final TextEditingController deadlineController = TextEditingController();

  var isLoading = false.obs;
  var userId = ''.obs;
  var username = ''.obs;
  var password = ''.obs;

  var roles = <Map<String, dynamic>>[].obs;
  var selectedRoleId = ''.obs;

  // users
  var usersAdmin = <Map<String, dynamic>>[].obs;
  var usersGudang = <Map<String, dynamic>>[].obs;

  // material
  var materialName = ''.obs;
  var stockQty = ''.obs;
  var unit = ''.obs;
  var materials = <Map<String, dynamic>>[].obs;

  // catalog item
  var catalogItems = <Map<String, dynamic>>[].obs;
  var title = ''.obs;
  var createdBy = ''.obs;
  var description = ''.obs;
  var price = ''.obs;
  var attachment = ''.obs;
  var selectedMaterials = <Map<String, dynamic>>[].obs;

  // material log
  var type = ''.obs;
  var qty = ''.obs;
  var note = ''.obs;
  var totalMasuk = 0.obs;
  var totalProduksi = 0.obs;
  var totalKeluar = 0.obs;
  final selectedMaterialForLog = Rx<Map<String, dynamic>?>(null);
  var materialLogs = <Map<String, dynamic>>[].obs;

  // order
  var deptStore = ''.obs;
  var deadline = Rxn<DateTime>();
  var notesOrder = ''.obs;
  var status = ''.obs;
  var orderNo = ''.obs;
  var selectedCatalogs = <Map<String, dynamic>>[].obs;
  var orders = <Map<String, dynamic>>[].obs;
  var orderDetail = {}.obs;

  // preparation order
  var prepOrders = <Map<String, dynamic>>[].obs;
  var notesPrep = ''.obs;
  var productionPIC = ''.obs;
  var approvalPIC = ''.obs;
  var selectedOrder = Rx<Map<String, dynamic>?>(null);

  // privileges
  var privileges = <Map<String, dynamic>>[].obs;
  var allPrivileges = <Map<String, dynamic>>[].obs;
  var userPrivileges = <String>[].obs;
  RxList<String> rolePrivileges = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadRoles();
    resetMaterials();
    loadOrders();
    loadMaterials();
    loadCatalog();
    getAllMaterialLogs();
    loadUsersByRole('ROLE001');
    loadUsersByRole('ROLE002');
  }

  void resetMaterials() {
    selectedMaterials.clear();
  }

  void logout() {
    username.value = '';
    selectedRoleId.value = '';
  }

  void setRolePrivileges(List<Map<String, dynamic>> privileges) {
    rolePrivileges.value =
        privileges.map((p) => p['privilegeCode'].toString()).toList();
  }

  Future<String?> encodeImageToBase64(String? path) async {
    if (path == null || path.isEmpty) return null;
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> loadRoles({bool isOwner = false}) async {
    try {
      final result = await apiService.fetchRoles();
      roles.assignAll(result);

      if (roles.isNotEmpty) {
        selectedRoleId.value = roles.first['id'].toString();
      }
    } catch (e) {
      print("Error loadRoles: $e");
    }
  }

  Future<void> loadUsersByRole(String id) async {
    try {
      final result = await apiService.getUserByRole(id);
      print("✅ Received ${result.length} users for $id");
      if (id == 'ROLE001') {
        usersAdmin.assignAll(result);
      } else {
        usersGudang.assignAll(result);
      }
    } catch (e) {
      print("Error to load users: $e");
    }
  }

  Future<void> loadOrders() async {
    try {
      final result = await apiService.loadOrders();
      orders.value = result;
    } catch (e) {
      print("Error loadOrders: $e");
    }
  }

  Future<void> loadPreparationOrders() async {
    try {
      final result = await apiService.loadPreparationOrders();
      prepOrders.value = result;
    } catch (e) {
      print("Error load Preparation Order: $e");
    }
  }

  Future<void> fetchOrderDetail(String orderNo) async {
    try {
      final data = await apiService.loadOrderById(orderNo);
      orderDetail.value = data;
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  String get selectedRoleName {
    if (selectedRoleId.value.isEmpty) return '';
    final role = roles.firstWhere(
      (r) => r['id'] == selectedRoleId.value,
      orElse: () => {'id': '', 'roleName': ''},
    );
    return role['roleName'] ?? '';
  }

  void register() async {
    isLoading.value = true;
    try {
      final result = await apiService.register(
        username.value,
        password.value,
        selectedRoleId.value,
      );

      print("Register success: $result");
      Get.snackbar(
        "Success",
        "Register success.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
      await Future.delayed(Duration(seconds: 1));
      Get.off(() => Login());
    } catch (e) {
      print("Register error: $e");
      Get.snackbar(
        "Error",
        "Register failed.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void login() async {
    isLoading.value = true;
    try {
      final result = await apiService.login(username.value, password.value);
      print(result);

      if (result != null && result.isNotEmpty) {
        userId.value = result['id'];
        username.value = result['username'];
        selectedRoleId.value = result['roleId'];

        if (roles.isEmpty) {
          roles.assignAll(await apiService.fetchRoles());
        }

        var roleName = selectedRoleName;

        // === LOAD PRIVILEGES ===
        final privilegesData =
            await apiService.getPrivilegesByRole(selectedRoleId.value);
        rolePrivileges.value =
            privilegesData.map((p) => p['privilegeCode'].toString()).toList();
        print("Loaded rolePrivileges: $rolePrivileges");

        if (roleName.isEmpty) {
          final ownerRoles = await apiService.fetchOwnerRole();
          if (ownerRoles.isNotEmpty) {
            roles.addAll(ownerRoles.map((r) => {
                  'id': r['id'],
                  'roleName': r['roleName'],
                  'isOwner': r['isOwner'],
                }));
            roleName = selectedRoleName;
          }
        }

        Get.snackbar(
          "Success",
          "Login Success",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 1),
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed('/home');
      } else {
        Get.snackbar(
          "Failed",
          "Login Failed. Please check your username/password.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateUser() async {
    isLoading.value = true;
    try {
      final result = await apiService.updateUser(
        userId.value,
        username.value,
        password.value,
        selectedRoleId.value,
      );
      if (result.contains("Update Profile Success")) {
        Get.snackbar(
          "Success",
          result,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
        await Future.delayed(Duration(seconds: 1));
        Get.off(() => HomePage());
      } else {
        print("Update error: " + result);
        Get.snackbar(
          "Error",
          result,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // ================== MATERIAL ===================
  Future<void> createMaterial() async {
    isLoading.value = true;
    try {
      final result = await apiService.insertMaterial(
        materialName.value,
        int.tryParse(stockQty.value) ?? 0,
        unit.value,
      );

      print("Material created: $result");

      Get.snackbar(
        "Success",
        "Success create material",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      materialName.value = "";
      stockQty.value = "";
      unit.value = "";

      await loadMaterials();

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => RawMaterials());
    } catch (e) {
      print("Error create material: $e");
      Get.snackbar(
        "Error",
        "Error void to create material",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMaterial(String id) async {
    try {
      isLoading.value = true;

      final updatedData = {
        "materialName": materialName.value,
        "stockQty": stockQty.value,
        "unit": unit.value,
      };

      final response = await apiService.updateMaterial(id, updatedData);
      print("Update berhasil: $response");

      await loadMaterials();

      Get.snackbar(
        "Success",
        "Success update material",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => RawMaterials());
    } catch (e) {
      print("Error updateMaterial: $e");
      Get.snackbar(
        "Error",
        "Error to update material",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMaterials(String id) async {
    try {
      await apiService.deleteMaterial(id);
      materials.removeWhere((m) => m['id'] == id);
      update();
      Get.snackbar(
        "Success",
        "Material deleted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete material",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
    }
  }

  Future<void> loadMaterials() async {
    try {
      final result = await apiService.getAllMaterials();
      materials.value = result;
    } catch (e) {
      print("Error loadMaterials: $e");
    }
  }

  // ============== CATALOG ITEM ==================
  Future<void> loadCatalog() async {
    try {
      final result = await apiService.getAllCatalog();
      print("Loaded catalog: $result");
      catalogItems.value = result;
    } catch (e) {
      print("Error loadCatalog: $e");
    }
  }

  Future<void> createCatalogItem() async {
    isLoading.value = true;
    try {
      final result = await apiService.insertCatalogItem(
        title.value,
        username.value,
        description.value,
        double.tryParse(price.value) ?? 0,
        attachment.value,
        selectedMaterials,
      );

      Get.snackbar(
        "Success",
        "Success create catalog item",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      title.value = '';
      description.value = '';
      price.value = '';
      attachment.value = '';

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => CatalogShoes());
    } catch (e) {
      print("Error create catalog: $e");
      Get.snackbar(
        "Error",
        "Error to create catalog item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCatalogItem(String id) async {
    try {
      isLoading.value = true;

      final updatedData = {
        "title": title.value,
        "description": description.value,
        "createdBy": createdBy.value,
        "price": price.value,
        "attachment": attachment.value,
        "materials": selectedMaterials,
      };

      final response = await apiService.updateCatalogItem(id, updatedData);
      print("Update berhasil: $response");

      await loadCatalog();

      Get.snackbar(
        "Success",
        "Success update catalog",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => RawMaterials());
    } catch (e) {
      print("Error updateCatalog: $e");
      Get.snackbar(
        "Error",
        "Error to update catalog",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCatalogItem(String id) async {
    try {
      await apiService.deleteCatalog(id);
      await loadCatalog();
      update();
      Get.snackbar(
        "Success",
        "Catalog Item deleted",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete catalog item",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );
    }
  }

  // ============= MATERIAL LOG ==============
  Future<void> createMaterialLog() async {
    isLoading.value = true;
    try {
      final result = await apiService.insertMaterialLog(
        username.value,
        note.value,
        int.tryParse(qty.value) ?? 0,
        type.value,
        selectedMaterialForLog.value,
      );

      Get.snackbar(
        "Success",
        "Success create material log",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      note.value = '';
      qty.value = '';

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => HomePage());
    } catch (e) {
      print("Error create material log: $e");
      Get.snackbar(
        "Error",
        "Error to create material log",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllMaterialLogs() async {
    try {
      final result = await apiService.getAllMaterialLogs();
      materialLogs.assignAll(result);
      print("Material logs result: $result");
    } catch (e) {
      print("Error load material logs: $e");
    }
  }

  Future<void> loadMaterialLogSummary() async {
    try {
      final result = await apiService.loadMaterialLogSummary();
      totalMasuk.value = result['totalMasuk'] ?? 0;
      totalKeluar.value = result['totalKeluar'] ?? 0;
      totalProduksi.value = result['totalProduksi'] ?? 0;
    } catch (e) {
      print("Error load summary: $e");
    }
  }

  // ======================== ORDER =====================
  Future<void> createOrder() async {
    isLoading.value = true;
    try {
      if (selectedCatalogs.isEmpty) {
        Get.snackbar(
          "Error",
          "Please select at least one catalog item.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );
        return;
      }

      if (deadline.value == null) {
        Get.snackbar(
          "Error",
          "Please pick a deadline",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        return;
      }

      final result = await apiService.insertOrder(
        orderNo.value,
        deptStore.value,
        deadline.value!,
        status.value,
        selectedCatalogs,
        attachment.value,
        notesOrder.value,
      );

      Get.snackbar(
        "Success",
        "Order created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      selectedCatalogs.clear();
      attachment.value = '';
      orderNo.value = '';
      deptStore.value = '';
      deadline.value = null;
      deadlineController.clear();
      notesOrder.value = '';
      status.value = '';

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => Order());
    } catch (e) {
      print("Error create order: $e");
      Get.snackbar(
        "Error",
        "Failed to create order",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== PREPARATION ORDER =====================
  Future<void> createPreparationOrder() async {
    isLoading.value = true;
    try {
      final result = await apiService.insertPreparationOrder(
        notesPrep.value,
        status.value,
        approvalPIC.value,
        productionPIC.value,
        selectedOrder.value,
      );

      print("Preparation Order created: $result");

      Get.snackbar(
        "Success",
        "Preparation Order created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 1),
      );

      notesPrep.value = '';
      status.value = '';
      approvalPIC.value = '';
      productionPIC.value = '';

      await loadPreparationOrders();

      await Future.delayed(Duration(seconds: 1));
      Get.off(() => PreparationOrder());
    } catch (e) {
      print("Error create preparation order: $e");
      Get.snackbar(
        "Error",
        "Failed to create Preparation Order",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void approvePreparationOrder(String orderId) async {
    try {
      final updated = await apiService.updatePreparationOrderStatus(
        orderId,
        "Ready to Process",
      );

      if (updated != null) {
        final index = prepOrders.indexWhere((order) => order["id"] == orderId);
        if (index != -1) {
          prepOrders[index] = updated;
          prepOrders.refresh();
        }

        Get.snackbar(
          "Success",
          "Preparation Order approved.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
      } else {
        Get.snackbar(
          "Error",
          "Preparation Order approval failed. Please contact the admin.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // =================== PRIVILEGES ==================
  Future<void> loadPrivilegesByRole(String roleId) async {
    try {
      final result = await apiService.getPrivilegesByRole(roleId);
      privileges.assignAll(result);
      print("Loaded ${result.length} privileges for role $roleId");
    } catch (e) {
      print("Error loadPrivilegesByRole: $e");
      Get.snackbar(
        "Error",
        "Gagal memuat privileges.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loadAllPrivileges() async {
    final result = await apiService.fetchAllPrivileges();
    allPrivileges.assignAll(result);
  }
}
