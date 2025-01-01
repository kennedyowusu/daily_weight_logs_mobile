import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';

InputDecoration inputDecoration = InputDecoration(
  hintText: '',
  hintStyle: const TextStyle(
    color: Color(0xFF898989),
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFF2F2F2), width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: secondaryColor,
    ),
  ),
  suffixIcon: const Icon(
    Icons.search,
    color: Color(0xFFBABABA),
    size: 30,
  ),
);
