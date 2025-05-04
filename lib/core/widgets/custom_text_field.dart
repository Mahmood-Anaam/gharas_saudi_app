import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? prefixText;
  final IconData? icon;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.obscureText = false,
    this.prefixText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: kMainColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        prefixText: prefixText,
        prefixIcon: icon != null ? Icon(icon, color: kMainColor) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 175, 203, 182),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
    );
  }
}
