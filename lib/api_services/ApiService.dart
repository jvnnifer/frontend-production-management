import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  final String baseUrl = "http://192.168.100.6:8080/api";

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
    // eksekusi request
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
    final response = await http.post(
      Uri.parse("$baseUrl/update-catalog/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(catalog),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update material: ${response.body}");
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

  Future<List<Map<String, dynamic>>> loadOrders() async {
    final response = await http.get(Uri.parse("$baseUrl/get-order"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to load order: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> loadOrderById(String orderNo) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/get-order-by-id?orderNo=${Uri.encodeQueryComponent(orderNo)}"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to load order: ${response.body}");
    }
  }
}
