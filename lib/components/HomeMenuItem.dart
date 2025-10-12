import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMenuItem {
  final IconData icon;
  final String label;
  final String route;
  final String privilegeCode;

  HomeMenuItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.privilegeCode,
  });
}

List<HomeMenuItem> allMenus = [
  HomeMenuItem(
      icon: FontAwesomeIcons.boxOpen,
      label: "Katalog",
      route: "/catalog",
      privilegeCode: "MANAGE_CATALOG"),
  HomeMenuItem(
      icon: Icons.shopping_cart,
      label: "Order",
      route: "/order",
      privilegeCode: "MANAGE_ORDER"),
  HomeMenuItem(
      icon: FontAwesomeIcons.industry,
      label: "Persiapan Produksi",
      route: "/preparationorder",
      privilegeCode: "MANAGE_PO"),
  HomeMenuItem(
      icon: FontAwesomeIcons.cubes,
      label: "Bahan Baku",
      route: "/rawmaterial",
      privilegeCode: "MANAGE_MATERIALS"),
  HomeMenuItem(
      icon: FontAwesomeIcons.boxArchive,
      label: "Material Log",
      route: "/materiallog",
      privilegeCode: "MANAGE_MATERIALLOG"),
  HomeMenuItem(
      icon: Icons.admin_panel_settings,
      label: "Role",
      route: "/managerole",
      privilegeCode: "MANAGE_ROLE"),
  HomeMenuItem(
      icon: Icons.rule,
      label: "Privilege",
      route: "/manageprivilege",
      privilegeCode: "MANAGE_PRIVILEGE"),
  HomeMenuItem(
      icon: Icons.dashboard,
      label: "Dashboard",
      route: "/dashboard",
      privilegeCode: "MANAGE_DASHBOARD"),
];

List<HomeMenuItem> getMenusByPrivileges(List<String> privileges,
    {bool includeHome = true}) {
  final filteredMenus = allMenus
      .where((menu) => privileges.contains(menu.privilegeCode))
      .toList();

  if (includeHome) {
    final homeMenu = HomeMenuItem(
      icon: Icons.home,
      label: "Home",
      route: "/home",
      privilegeCode: "HOME",
    );
    return [homeMenu, ...filteredMenus];
  }

  return filteredMenus;
}
