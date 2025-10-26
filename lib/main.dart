import 'package:flutter/material.dart';
import 'package:Prodify/controller/AuthController.dart';
import 'package:Prodify/pages/Login.dart';
import 'package:Prodify/pages/Register.dart';
import 'package:Prodify/pages/admin/CatalogShoes.dart';
import 'package:Prodify/pages/admin/CreateOrder.dart';
import 'package:Prodify/pages/admin/Order.dart';
import 'package:Prodify/pages/admin/OrderDetail.dart';
import 'package:Prodify/pages/owner/DashboardPage.dart';
import 'package:Prodify/pages/owner/Privileges.dart';
import 'package:Prodify/pages/owner/Role.dart';
import 'package:Prodify/pages/warehouse/CreateMaterial.dart';
import 'package:Prodify/pages/warehouse/CreateMaterialLog.dart';
import 'package:Prodify/pages/admin/CreateProduct.dart';
import 'package:Prodify/pages/HomePage.dart';
import 'package:get/get.dart';
import 'package:Prodify/pages/UserSetting.dart';
import 'package:Prodify/pages/warehouse/CreatePreparationOrder.dart';
import 'package:Prodify/pages/warehouse/MaterialLog.dart';
import 'package:Prodify/pages/warehouse/PreparationOrder.dart';
import 'package:Prodify/pages/warehouse/RawMaterials.dart';
import 'controller/SidebarController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SidebarController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    getPages: [
      GetPage(name: '/register', page: () => Register()),
      GetPage(name: '/home', page: () => HomePage()),
      GetPage(name: '/create', page: () => CreateProduct()),
      GetPage(name: '/catalog', page: () => CatalogShoes()),
      GetPage(name: '/usersetting', page: () => UserSetting()),
      GetPage(name: '/creatematerial', page: () => CreateMaterial()),
      GetPage(name: '/createmateriallog', page: () => CreateMaterialLog()),
      GetPage(name: '/createorder', page: () => CreateOrder()),
      GetPage(name: '/createPrepOrder', page: () => CreatePreparationOrder()),
      GetPage(name: '/preparationorder', page: () => PreparationOrder()),
      GetPage(name: '/rawmaterial', page: () => RawMaterials()),
      GetPage(name: '/login', page: () => Login()),
      GetPage(name: '/order', page: () => Order()),
      GetPage(name: '/materiallog', page: () => MaterialLog()),
      GetPage(name: '/orderdetail', page: () => OrderDetail()),
      GetPage(name: '/manageprivilege', page: () => Privileges()),
      GetPage(name: '/managerole', page: () => Role()),
      GetPage(name: '/dashboard', page: () => DashboardPage())
    ],
  ));
}
