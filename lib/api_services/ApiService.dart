import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = "https://zora-superfine-ceola.ngrok-free.dev/api";

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      return null;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  Future<String> register(String username, String password, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/user/register"),
      body: {
        'username': username,
        'password': password,
        'roleId': role,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to register");
    }
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/user/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<List<Map<String, dynamic>>> getUserByRole(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/get-user-by-role/$id"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<String> updateUser(
      String id, String username, String password, String role) async {
    final response = await http.put(
      Uri.parse("$baseUrl/updateuser/$id"),
      body: {
        'username': username,
        'password': password,
        'roleId': role,
      },
    );

    if (response.statusCode == 200) {
      return "Update Profile Success";
    } else {
      throw Exception("Failed to update user");
    }
  }

  Future<List<Map<String, dynamic>>> fetchRoles() async {
    final response = await http.get(Uri.parse("$baseUrl/roles"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load roles: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchOwnerRole() async {
    final response = await http.get(Uri.parse("$baseUrl/owner-role"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch owner roles: ${response.statusCode}");
    }
  }

  // ========================= MATERIAL =============================

  Future<Map<String, dynamic>> insertMaterial(
      String materialName, int stockQty, String unit) async {
    final response = await http.post(
      Uri.parse("$baseUrl/material"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'materialName': materialName,
        'stockQty': stockQty,
        'unit': unit,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to insert material: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> updateMaterial(
      String id, Map<String, dynamic> material) async {
    final response = await http.post(
      Uri.parse("$baseUrl/update-material/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(material),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update material: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getAllMaterials() async {
    final response = await http.get(Uri.parse("$baseUrl/get-materials"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load materials: ${response.body}");
    }
  }

  Future<String> deleteMaterial(String id) async {
    final response = await http.post(Uri.parse("$baseUrl/delete-material/$id"));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete material: ${response.body}");
    }
  }

  // ===================== CATALOG ITEM ======================
  Future<void> insertCatalogItem(
    String title,
    String username,
    String description,
    double price,
    String? attachmentPath,
    List<Map<String, dynamic>> selectedMaterials,
  ) async {
    var uri = Uri.parse("$baseUrl/catalog");
    var request = http.MultipartRequest("POST", uri);

    request.fields['title'] = title;
    request.fields['createdBy'] = username;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['materials'] = jsonEncode(
      selectedMaterials
          .map((m) => {
                "materialId": m["id"],
                "reqQty": m["reqQty"],
              })
          .toList(),
    );

    // kalau ada file
    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath("file", attachmentPath),
      );
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Catalog created");
    } else {
      print("Failed: ${response.statusCode}");
      print(await response.stream.bytesToString());
    }
  }

  Future<Map<String, dynamic>> updateCatalogItem(
      String id, Map<String, dynamic> catalog) async {
    var url = Uri.parse("$baseUrl/update-catalog/$id");

    var request = http.MultipartRequest('PUT', url);

    request.fields['title'] = catalog['title'] ?? '';
    request.fields['createdBy'] = catalog['createdBy'] ?? '';
    request.fields['description'] = catalog['description'] ?? '';
    request.fields['price'] = catalog['price']?.toString() ?? '0';

    final materials = (catalog['materials'] as List<Map<String, dynamic>>)
        .map((m) => {
              "materialId": m["id"],
              "reqQty": m["reqQty"],
            })
        .toList();

    request.fields['materials'] = jsonEncode(materials);

    final fileData = catalog['file'];
    if (fileData != null && fileData is String) {
      if (fileData.startsWith('/9j/') || fileData.startsWith('iVBOR')) {
        final bytes = base64Decode(fileData);
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'upload.png',
        ));
      } else if (fileData.endsWith('.jpg') ||
          fileData.endsWith('.jpeg') ||
          fileData.endsWith('.png')) {
        request.files.add(await http.MultipartFile.fromPath('file', fileData));
      }
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("Catalog updated successfully: $responseBody");
      return jsonDecode(responseBody);
    } else {
      print("Failed to update catalog: ${response.statusCode} - $responseBody");
      throw Exception("Failed to update catalog");
    }
  }

  Future<List<Map<String, dynamic>>> getAllCatalog() async {
    final response = await http.get(Uri.parse("$baseUrl/get-catalog"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load catalog: ${response.body}");
    }
  }

  Future<String> deleteCatalog(String id) async {
    final response = await http.post(Uri.parse("$baseUrl/delete-catalog/$id"));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete catalog: ${response.body}");
    }
  }

  // ===================== MATERIAL BY CATALOG ======================
  Future<Map<String, dynamic>> getMaterialsForCatalog(String catalogId) async {
    final url = Uri.parse("$baseUrl/get-materials-for-catalog/$catalogId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to load materials: ${response.body}");
    }
  }

  // ===================== MATERIAL LOG =====================
  Future<Map<String, dynamic>> insertMaterialLog(
    String username,
    String note,
    int qty,
    String type,
    Map<String, dynamic>? material,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/material-log"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "createdBy": username,
        "note": note,
        "type": type,
        "qty": qty,
        "createdDate": DateTime.now().toIso8601String(),
        "material": {"id": material?['id']}
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to insert material log: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> getAllMaterialLogs() async {
    final response = await http.get(Uri.parse("$baseUrl/get-material-log"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load material logs: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> loadMaterialLogSummary() async {
    final response = await http.get(Uri.parse("$baseUrl/material-log/summary"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load material log summary: ${response.body}");
    }
  }

  // ================ ORDER =================
  Future<void> insertOrder(
      String orderNo,
      String deptStore,
      DateTime deadline,
      String status,
      List<Map<String, dynamic>> orderCatalog,
      String? attachmentPath,
      String notes) async {
    var uri = Uri.parse("$baseUrl/order");
    var request = http.MultipartRequest("POST", uri);

    request.fields['orderNo'] = orderNo;
    request.fields['deptStore'] = deptStore;
    request.fields['deadline'] = DateFormat('yyyy-MM-dd').format(deadline);
    request.fields['status'] = status;
    request.fields['notes'] = notes;
    request.fields['orderCatalog'] = jsonEncode(
      orderCatalog
          .map((m) => {
                "catalog_id": m["catalog_id"],
                "qty": m["qty"],
              })
          .toList(),
    );

    // kalau ada file
    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath("file", attachmentPath),
      );
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Order created");
    } else {
      print("Order failed to created");
    }
  }

  Future<Map<String, dynamic>> updateOrder(
      String orderNo, Map<String, dynamic> order) async {
    var url = Uri.parse("$baseUrl/update-order/$orderNo");
    print("$orderNo");
    var request = http.MultipartRequest('PUT', url);

    request.fields['deptStore'] = order['deptStore'] ?? '';
    request.fields['deadline'] = order['deadline'] ?? '';
    request.fields['status'] = order['status'] ?? '';
    request.fields['notes'] = order['notes'] ?? '';

    request.fields['orderCatalog'] = jsonEncode(
      (order['orderCatalog'] as List)
          .map((c) => {
                "catalogId": c["catalogId"],
                "qty": c["qty"],
              })
          .toList(),
    );

    final fileData = order['file'];
    if (fileData != null && fileData is String) {
      if (fileData.startsWith('/9j/') || fileData.startsWith('iVBOR')) {
        final bytes = base64Decode(fileData);
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'upload.png',
        ));
      } else if (fileData.endsWith('.jpg') ||
          fileData.endsWith('.jpeg') ||
          fileData.endsWith('.png')) {
        request.files.add(await http.MultipartFile.fromPath('file', fileData));
      }
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print("Order updated successfully: $responseBody");
      return jsonDecode(responseBody);
    } else {
      print("Failed: ${response.statusCode} - $responseBody");
      throw Exception("Failed to update order");
    }
  }

  Future<List<Map<String, dynamic>>> loadOrders() async {
    final response = await http.get(Uri.parse("$baseUrl/get-order"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load order: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> loadPreparationOrders() async {
    final response =
        await http.get(Uri.parse("$baseUrl/get-preparation-order"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load preparation order: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> loadOrderById(String orderNo) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/get-order-by-id?orderNo=${Uri.encodeQueryComponent(orderNo)}"));

    print("🔍 Response get-order-by-id ($orderNo): ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to load order: ${response.body}");
    }
  }

  //  ================== PREPARATION ORDER ==========================
  Future<Map<String, dynamic>> insertPreparationOrder(
      String note,
      String status,
      String approvalPIC,
      String productionPIC,
      Map<String, dynamic>? selectedOrder) async {
    final body = jsonEncode({
      'note': note,
      'status': status,
      'approvalPic': approvalPIC,
      'productionPic': productionPIC,
      'orders': {'orderNo': selectedOrder?['orderNo']},
    });

    final response = await http.post(
      Uri.parse("$baseUrl/preparation-order"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to insert preparation order: ${response.body}");
    }
  }

  Future<Map<String, dynamic>?> updatePreparationOrderStatus(
      String id, String status) async {
    final url = Uri.parse('$baseUrl/update-preporder-status/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'status': status}),
    );

    print('URL: $url');
    print('Body: ${jsonEncode({'status': status})}');
    print('Response: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // ============== MANAGE ROLE ========================
  Future<List<Map<String, dynamic>>> getPrivilegesByRole(String roleId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/$roleId/privileges"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load privileges: ${response.body}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllPrivileges() async {
    final response = await http.get(
      Uri.parse("$baseUrl/allprivileges"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load all privileges: ${response.body}");
    }
  }

  Future<void> saveRolePrivileges(
      String roleId, List<String> selectedPrivileges) async {
    final url = Uri.parse("$baseUrl/update-privileges/$roleId");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(selectedPrivileges),
      );

      if (response.statusCode == 200) {
        print('Privileges updated successfully');
      } else {
        print('Failed to update privileges: ${response.body}');
      }
    } catch (e) {
      print('Error updating privileges: $e');
    }
  }

  // =============== DASHBOARD ====================
  // Preparation Order per Year
  Future<Map<int, int>> getPreparationOrderPerYear() async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/preparation-order/yearly"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // convert key dari String ke int
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } else {
      throw Exception(
          "Failed to load preparation order yearly: ${response.body}");
    }
  }

// Preparation Order per Month
  Future<Map<int, int>> getPreparationOrderPerMonth(int year) async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/preparation-order/monthly?year=$year"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } else {
      throw Exception(
          "Failed to load preparation order monthly: ${response.body}");
    }
  }

// Optional: Orders per Year / Month
  Future<Map<int, int>> getOrderPerYear() async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/order/yearly"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } else {
      throw Exception("Failed to load order yearly: ${response.body}");
    }
  }

  Future<Map<int, int>> getOrderPerMonth(int year) async {
    final response = await http.get(
      Uri.parse("$baseUrl/dashboard/order/monthly?year=$year"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data.map((key, value) => MapEntry(int.parse(key), value as int));
    } else {
      throw Exception("Failed to load order monthly: ${response.body}");
    }
  }
}
