import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? initialValue;
  final Color baseColor;
  final ValueChanged<String?>? onChanged;

  const DropdownWidget({
    super.key,
    required this.label,
    required this.items,
    this.initialValue,
    this.baseColor = const Color(0xFF80CBC4),
    this.onChanged,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ??
        (widget.items.isNotEmpty ? widget.items.first : "");
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: selectedValue,
      expandedInsets: EdgeInsets.zero,
      label: Text(
        widget.label,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14),
      ),
      onSelected: (String? value) {
        setState(() {
          selectedValue = value!;
        });

        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      dropdownMenuEntries: widget.items
          .map((item) => DropdownMenuEntry(
                value: item,
                label: item,
                style: MenuItemButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ))
          .toList(),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(widget.baseColor),
      ),
      textStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w600,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: widget.baseColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.baseColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.baseColor, width: 2.5),
        ),
      ),
    );
  }
}
