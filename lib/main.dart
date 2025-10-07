import 'package:flutter/material.dart';
import 'package:jago_app/controller/AuthController.dart';
import 'package:jago_app/pages/Login.dart';
import 'package:jago_app/pages/Register.dart';
import 'package:jago_app/pages/admin/CatalogShoes.dart';
import 'package:jago_app/pages/admin/CreateOrder.dart';
import 'package:jago_app/pages/admin/Order.dart';
import 'package:jago_app/pages/admin/OrderDetail.dart';
import 'package:jago_app/pages/warehouse/CreateMaterial.dart';
import 'package:jago_app/pages/warehouse/CreateMaterialLog.dart';
import 'package:jago_app/pages/admin/CreateProduct.dart';
import 'package:jago_app/pages/HomePage.dart';
import 'package:get/get.dart';
import 'package:jago_app/pages/UserSetting.dart';
import 'package:jago_app/pages/warehouse/CreatePreparationOrder.dart';
import 'package:jago_app/pages/warehouse/MaterialLog.dart';
import 'package:jago_app/pages/warehouse/PreparationOrder.dart';
import 'package:jago_app/pages/warehouse/RawMaterials.dart';
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
    ],
  ));
}
