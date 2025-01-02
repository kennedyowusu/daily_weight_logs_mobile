import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  required String hintText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    fillColor: Colors.white,
    hintStyle: const TextStyle(
      color: grayTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: grayTextColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: grayTextColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),
    suffixIcon: suffixIcon,
  );
}
