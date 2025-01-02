import 'package:flutter/material.dart';

class HeightLogRepository {
  Future<void> saveHeightLog(double height, String weightGoal) async {
    // Simulate a network or database operation
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Height: $height, Weight Goal: $weightGoal');
  }
}
