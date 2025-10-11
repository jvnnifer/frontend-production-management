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
];

// === DATA GUDANG ===
List<SideMenuModel> sideMenusGudang = [
  SideMenuModel(
    title: "Bahan Baku",
    icon: const FaIcon(FontAwesomeIcons.cubes, color: Colors.white),
    route: "/rawmaterial",
  ),
  SideMenuModel(
    title: "Material Log",
    icon: const FaIcon(FontAwesomeIcons.boxArchive, color: Colors.white),
    route: "/materiallog",
  ),
  SideMenuModel(
    title: "Persiapan Produksi",
    icon: const Icon(Icons.receipt_long, color: Colors.white),
    route: "/preparationorder",
  ),
];

// === DATA ADMIN ===
List<SideMenuModel> sideMenusAdmin = [
  SideMenuModel(
    title: "Catalog Item",
    icon: const FaIcon(FontAwesomeIcons.boxOpen, color: Colors.white),
    route: "/catalog",
  ),
  SideMenuModel(
    title: "Order",
    icon: const Icon(Icons.shopping_cart, color: Colors.white),
    route: "/order",
  ),
  SideMenuModel(
    title: "Persiapan Produksi",
    icon: const Icon(Icons.receipt_long, color: Colors.white),
    route: "/preparationorder",
  ),
];

// === HAK AKSES ===
List<SideMenuModel> sideMenus3 = [
  SideMenuModel(
    title: "Dashboard",
    icon: const Icon(Icons.dashboard, color: Colors.white),
    route: "/dashboard",
  ),
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

List<SideMenuModel> getMenuByRole(String roleCode) {
  List<SideMenuModel> menus = [...sideMenus];

  switch (roleCode) {
    case "ROLE001": // ADMIN
      menus.addAll(sideMenusAdmin);
      break;

    case "ROLE002": // GUDANG
      menus.addAll(sideMenusGudang);
      break;

    case "ROLE003": // OWNER
      menus.addAll([
        ...sideMenus3, // hak akses
        SideMenuModel(
          title: "Dashboard",
          icon: const Icon(Icons.dashboard, color: Colors.white),
          route: "/dashboard",
        ),
      ]);
      break;

    default:
      break;
  }

  return menus;
}
