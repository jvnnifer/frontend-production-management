import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SideMenuModel.dart';

// === UTAMA ===
List<SideMenuModel> sideMenus = [
  SideMenuModel(
    title: "Home",
    icon: const Icon(Icons.home, color: Colors.white),
    route: "/home",
  ),
  SideMenuModel(
    title: "Dashboard",
    icon: const Icon(Icons.dashboard, color: Colors.white),
    route: "/dashboard",
  ),
  SideMenuModel(
    title: "Persiapan Produksi",
    icon: const Icon(Icons.receipt_long, color: Colors.white),
    route: "/createPrepOrder",
  ),
];

// === DATA GUDANG ===
List<SideMenuModel> sideMenusGudang = [
  SideMenuModel(
    title: "Create Bahan Baku",
    icon: const FaIcon(FontAwesomeIcons.cubes, color: Colors.white),
    route: "/creatematerial",
  ),
  SideMenuModel(
    title: "Create Material Log",
    icon: const FaIcon(FontAwesomeIcons.boxArchive, color: Colors.white),
    route: "/createmateriallog",
  ),
];

// === DATA ADMIN ===
List<SideMenuModel> sideMenusAdmin = [
  SideMenuModel(
    title: "Create Catalog Item",
    icon: const FaIcon(FontAwesomeIcons.boxOpen, color: Colors.white),
    route: "/create",
  ),
  SideMenuModel(
    title: "Create Order",
    icon: const Icon(Icons.shopping_cart, color: Colors.white),
    route: "/createorder",
  ),
];

// === HAK AKSES ===
List<SideMenuModel> sideMenus3 = [
  SideMenuModel(
    title: "Kelola Role",
    icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
    route: "/managerole",
  ),
  SideMenuModel(
    title: "Kelola Privilege",
    icon: const Icon(Icons.rule, color: Colors.white),
    route: "/manageprivilege",
  ),
];
