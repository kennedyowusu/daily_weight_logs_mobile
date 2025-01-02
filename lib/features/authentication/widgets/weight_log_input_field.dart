import 'package:daily_weight_logs_mobile/common/utils/input_decoration.dart';
import 'package:flutter/material.dart';

class WeightLogInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Color inputTextColor;

  const WeightLogInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.inputTextColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      controller: controller,
      obscureText: obscureText,
      decoration: customInputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      style: TextStyle(
        color: inputTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
    );
  }
}
