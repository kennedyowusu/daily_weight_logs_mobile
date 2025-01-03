import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/utils/theme.dart';
import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/router/app_router.dart';
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
      return MainRoutes.weightLogRoute;
    } else if (seenOnboarding) {
      return InitialRoutes.loginRoute;
    } else {
      return InitialRoutes.onboardingRoute;
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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildThemeData(),
            initialRoute: snapshot.data,
            onGenerateRoute: AppRouter.generateRoute,
          );
        }
      },
    );
  }
}
