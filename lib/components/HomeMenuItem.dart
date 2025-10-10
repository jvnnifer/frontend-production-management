import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMenuItem {
  final IconData icon;
  final String label;
  final String route;

  HomeMenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

List<HomeMenuItem> getHomeMenuByRole(String roleCode) {
  switch (roleCode) {
    case "ROLE001": // ADMIN
      return [
        HomeMenuItem(
            icon: FontAwesomeIcons.boxOpen,
            label: "Katalog",
            route: "/catalog"),
        HomeMenuItem(
            icon: Icons.shopping_cart, label: "Order", route: "/order"),
      ];

    case "ROLE002": // GUDANG
      return [
        HomeMenuItem(
            icon: FontAwesomeIcons.industry,
            label: "Persiapan Produksi",
            route: "/preparationorder"),
        HomeMenuItem(
            icon: FontAwesomeIcons.cubes,
            label: "Bahan Baku",
            route: "/rawmaterial"),
        HomeMenuItem(
            icon: FontAwesomeIcons.boxArchive,
            label: "Material Log",
            route: "/materiallog"),
      ];

    case "ROLE003": // OWNER
      return [
        HomeMenuItem(
            icon: Icons.admin_panel_settings,
            label: "Role",
            route: "/managerole"),
        HomeMenuItem(
            icon: Icons.rule, label: "Privilege", route: "/manageprivilege"),
        HomeMenuItem(
            icon: Icons.dashboard, label: "Dashboard", route: "/dashboard"),
      ];

    default:
      return [
        HomeMenuItem(icon: Icons.home, label: "Home", route: "/home"),
      ];
  }
}
