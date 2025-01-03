import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';

class OnboardingController extends StateNotifier<bool> {
  final DailyWeightLogsSecureStorage storage;

  OnboardingController(this.storage) : super(false);

  Future<void> checkOnboardingStatus() async {
    final bool completed = await storage.isUserSeenOnboarding();
    state = completed;
  }

  Future<void> completeOnboarding() async {
    await storage.setIsUserSeenOnboarding(true);
    state = true;
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>(
  (ref) => OnboardingController(DailyWeightLogsSecureStorage()),
);
