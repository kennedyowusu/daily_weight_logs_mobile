import 'package:daily_weight_logs_mobile/common/constants/app_key.dart';
import 'package:daily_weight_logs_mobile/common/utils/secure_storage.dart';
import 'package:daily_weight_logs_mobile/common/utils/theme.dart';
import 'package:daily_weight_logs_mobile/features/not_found/presentation/not_found_screen.dart';
import 'package:daily_weight_logs_mobile/router/app_router.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    APIService.initializeInterceptors();

  final storage = DailyWeightLogsSecureStorage();
  final isOnboardingCompleted = await storage.isUserSeenOnboarding();

  runApp(
    ProviderScope(
      child: MyApp(isOnboardingCompleted: isOnboardingCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isOnboardingCompleted;

  const MyApp({super.key, required this.isOnboardingCompleted});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weight Log',
      navigatorKey: appNavigatorKey,
      theme: buildThemeData(),
      initialRoute: isOnboardingCompleted
          ? InitialRoutes.loginRoute
          : InitialRoutes.onboardingRoute,
      onGenerateRoute: AppRouter.generateRoute,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        );
      },
    );
  }
}
