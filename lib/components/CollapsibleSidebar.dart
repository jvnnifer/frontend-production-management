import 'package:flutter/material.dart';
import 'SideMenuBar.dart';

class CollapsibleSidebar extends StatelessWidget {
  final bool isCollapsed;
  final VoidCallback toggleSidebar;
  final String selectedRoute;
  final Function(String) onSelected;

  const CollapsibleSidebar({
    super.key,
    required this.isCollapsed,
    required this.toggleSidebar,
    required this.selectedRoute,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          left: isCollapsed ? -260 : 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 260,
            height: double.infinity,
            color: Colors.blueGrey[900],
            child: SideMenuBar(
              isCollapsed: isCollapsed,
              onMenuTap: toggleSidebar,
              selectedRoute: selectedRoute,
              onSelected: onSelected,
            ),
          ),
        ),
        if (!isCollapsed)
          Positioned(
            top: 40,
            left: 260,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.cancel,
                  size: 30,
                  color: Colors.black,
                ),
                padding: EdgeInsets.zero,
                onPressed: toggleSidebar,
              ),
            ),
          ),
      ],
    );
  }
}
