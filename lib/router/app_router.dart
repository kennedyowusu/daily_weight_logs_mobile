import 'package:daily_weight_logs_mobile/features/authentication/presentation/login_screen.dart';
import 'package:daily_weight_logs_mobile/features/not_found/presentation/not_found_screen.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:daily_weight_logs_mobile/router/initial_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final InitialRoutes initialRoutes = InitialRoutes();

  // Generate route method
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Authentication routes
      case InitialRoutes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case InitialRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      // Undefined routes
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        );
    }
  }
}
