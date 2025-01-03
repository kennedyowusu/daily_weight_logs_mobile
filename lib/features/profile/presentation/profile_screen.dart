import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 86.0),
            child: ElevatedButton(
              onPressed: () async {
                // Call logout method
                await ref.read(authControllerProvider.notifier).logout();

                // Navigate to login screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  InitialRoutes.loginRoute,
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text('Logout'),
            ),
          ),
        ),
      ),
    );
  }
}
