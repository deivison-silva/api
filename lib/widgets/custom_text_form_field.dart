import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputAction textInputAction;
  final bool readOnly;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputAction,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: readOnly ? Colors.grey : Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: readOnly ? Colors.grey : Colors.teal),
        ),
      ),
      readOnly: readOnly,
      textInputAction: textInputAction,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Preencha o campo';
        }
        return null;
      },
    );
  }
}
