import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jago_app/components/HomeMenuItem.dart';

class SideMenuTile extends StatelessWidget {
  final HomeMenuItem menu;
  final bool isActive;
  final VoidCallback press;

  const SideMenuTile({
    super.key,
    required this.menu,
    required this.isActive,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isActive ? Color(0xFF80CBC4).withOpacity(0.2) : Colors.transparent,
        border: isActive
            ? const Border(
                left: BorderSide(color: Colors.teal, width: 8),
              )
            : null,
      ),
      child: ListTile(
        leading: FaIcon(
          menu.icon,
          color: isActive ? Colors.tealAccent : Colors.white,
        ),
        title: Text(
          menu.label,
          style: TextStyle(
            color: isActive ? Colors.tealAccent : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: press,
      ),
    );
  }
}
