import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdownWidget extends StatefulWidget {
  final String label;
  final List<Map<String, dynamic>> itemsMaterial;
  final Map<String, dynamic>? initialValue;
  final Color baseColor;
  final void Function(Map<String, dynamic>?)? onChanged;
  final String Function(Map<String, dynamic>?)? itemAsString;

  const SearchableDropdownWidget({
    super.key,
    required this.label,
    required this.itemsMaterial,
    this.initialValue,
    this.baseColor = const Color(0xFF80CBC4),
    this.onChanged,
    this.itemAsString,
  });

  @override
  State<SearchableDropdownWidget> createState() =>
      _SearchableDropdownWidgetState();
}

class _SearchableDropdownWidgetState extends State<SearchableDropdownWidget> {
  Map<String, dynamic>? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Map<String, dynamic>>(
      items: widget.itemsMaterial,
      selectedItem: selectedValue,
      itemAsString: widget.itemAsString ??
          (Map<String, dynamic>? m) => m?['name']?.toString() ?? '',
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Cari ${widget.label}...",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: widget.label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.baseColor, width: 1.3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.baseColor, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.baseColor, width: 1.3),
          ),
        ),
      ),
      onChanged: (value) {
        setState(() => selectedValue = value);
        if (widget.onChanged != null) widget.onChanged!(value);
      },
    );
  }
}
