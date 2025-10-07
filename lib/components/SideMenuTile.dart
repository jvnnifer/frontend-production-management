import 'package:flutter/material.dart';
import 'SideMenuModel.dart';

class SideMenuTile extends StatelessWidget {
  final SideMenuModel menu;
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
        leading: menu.icon,
        title: Text(
          menu.title,
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
