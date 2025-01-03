import 'package:daily_weight_logs_mobile/common/utils/secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/authentication/presentation/login_screen.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_screen.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/presentation/weight_log_screen.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  APIService.initializeInterceptors();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> determineInitialRoute() async {
    final secureStorage = DailyWeightLogsSecureStorage();
    final bool seenOnboarding = await secureStorage.isUserSeenOnboarding();
    final bool isLoggedIn = await secureStorage.isUserLoggedIn();

    if (isLoggedIn) {
      return MainRoutes.weightLogRoute; // Redirect to weight logs screen
    } else if (seenOnboarding) {
      return InitialRoutes.loginRoute; // Redirect to login screen
    } else {
      return InitialRoutes.onboardingRoute; // Redirect to onboarding screen
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    return FutureBuilder<String>(
      future: determineInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: snapshot.data,
            routes: {
              InitialRoutes.onboardingRoute: (context) =>
                  const OnboardingScreen(),
              InitialRoutes.loginRoute: (context) => const LoginScreen(),
              MainRoutes.weightLogRoute: (context) => const WeightLogScreen(),
            },
          );
        }
      },
    );
  }
}
