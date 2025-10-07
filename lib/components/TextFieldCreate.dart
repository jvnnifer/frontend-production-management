import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFieldCreate extends StatefulWidget {
  const TextFieldCreate({
    super.key,
    required this.name,
    this.keyboardType = TextInputType.text,
    this.width,
    this.isDate = false,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.onChanged,
  });

  final String name;
  final TextInputType keyboardType;
  final double? width;
  final bool isDate;
  final TextEditingController? controller;
  final bool obscureText;
  final String? initialValue;
  final Function(dynamic)? onChanged;

  @override
  State<TextFieldCreate> createState() => _TextFieldCreateState();
}

class _TextFieldCreateState extends State<TextFieldCreate> {
  final TextEditingController _internalController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formatted = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        (widget.controller ?? _internalController).text = formatted;
      });

      widget.onChanged?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveController =
        widget.controller ?? (widget.isDate ? _internalController : null);

    final textField = TextFormField(
      controller: effectiveController,
      readOnly: widget.isDate,
      onTap: widget.isDate ? _pickDate : null,
      keyboardType: widget.isDate ? TextInputType.none : widget.keyboardType,
      obscureText: widget.obscureText,
      initialValue: effectiveController == null ? widget.initialValue : null,
      inputFormatters: widget.keyboardType == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
      onChanged: widget.onChanged,
      cursorColor: Colors.black87,
      decoration: InputDecoration(
        hintText: 'Masukkan ${widget.name}',
        hintStyle: const TextStyle(fontSize: 14),
        labelStyle: const TextStyle(
          color: Color(0xFF80CBC4),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF80CBC4), width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF80CBC4),
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );

    return widget.width != null
        ? SizedBox(width: widget.width, child: textField)
        : textField;
  }
}
