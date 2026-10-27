import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputAction textInputAction;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
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
