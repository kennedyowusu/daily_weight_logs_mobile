import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/utils/input_decoration.dart';
import 'package:flutter/material.dart';

class WeightLogInputField extends StatefulWidget {
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
  State<WeightLogInputField> createState() => _WeightLogInputFieldState();
}

class _WeightLogInputFieldState extends State<WeightLogInputField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscureText: isObscured,
      decoration: customInputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: grayTextColor,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
      ),
      style: TextStyle(
        color: widget.inputTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      validator: widget.validator,
    );
  }
}
