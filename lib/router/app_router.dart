import 'package:daily_weight_logs_mobile/features/authentication/presentation/forgot_password.dart';
import 'package:daily_weight_logs_mobile/features/authentication/presentation/login_screen.dart';
import 'package:daily_weight_logs_mobile/features/authentication/presentation/register_screen.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/presentation/height_log_screen.dart';
import 'package:daily_weight_logs_mobile/features/not_found/presentation/not_found_screen.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:daily_weight_logs_mobile/features/profile/presentation/profile_screen.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/presentation/add_weight_log.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/presentation/view_all_weight_logs.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/presentation/weight_log_screen.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:flutter/material.dart';

class AppRouter {
  final InitialRoutes initialRoutes = InitialRoutes();

  // Generate route method
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Unauthenticated routes
      case InitialRoutes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case InitialRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case InitialRoutes.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case InitialRoutes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      // Authenticated routes
      case MainRoutes.heightLogRoute:
        return MaterialPageRoute(builder: (_) => const HeightLogScreen());
      case MainRoutes.weightLogRoute:
        return MaterialPageRoute(builder: (_) => const WeightLogScreen());
      case MainRoutes.addWeightLogRoute:
        return MaterialPageRoute(builder: (_) => const AddWeightLogScreen());
      case MainRoutes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case MainRoutes.viewAllWeightLogsRoute:
        return MaterialPageRoute(builder: (_) => const ViewAllWeightLogs());

      // Undefined routes
      default:
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        );
    }
  }
}
