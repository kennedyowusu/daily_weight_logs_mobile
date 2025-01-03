import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text_button.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/application/onboarding_controller.dart';
import 'package:daily_weight_logs_mobile/features/onboarding/presentation/onboarding_slide.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _skippedToLastPage = false;

  @override
  Widget build(BuildContext context) {
    final onboardingController =
        ref.watch(onboardingControllerProvider.notifier);

    final List<OnboardingSlide> slides = [
      const OnboardingSlide(
        image: activityTracker,
        title: 'Track Your Weight',
        description:
            'Easily track your weight twice daily and monitor your progress over time.',
      ),
      const OnboardingSlide(
        image: percentages,
        title: 'Stay on Track',
        description:
            'Organize your weight records and view historical trends for better insights.',
      ),
      const OnboardingSlide(
        image: progressTracking,
        title: 'Reach Your Goals',
        description:
            'Set your target weight and let us help you stay motivated to achieve it.',
      ),
    ];

    return PopScope(
      onPopInvoked: (bool didPop) {
        if (_skippedToLastPage) {
          return;
        }
        return;
      },
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;

                debugPrint('Current page: $_currentPage');

                // Reset the "skippedToLastPage" flag when navigating normally
                if (page < slides.length - 1) {
                  _skippedToLastPage = false;
                }
              });
            },
            itemBuilder: (context, index) {
              return slides[index];
            },
          ),
        ),
        bottomSheet: _buildBottomSheet(context, onboardingController),
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, OnboardingController controller) {
    final bool isLastPage = _currentPage == 2;
    final bool isFirstPage = _currentPage == 0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: isLastPage && _skippedToLastPage
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          // Back or Skip button
          if (!isLastPage || !_skippedToLastPage)
            isFirstPage
                ? WeightLogTextButton(
                    key: const Key('skip_button'),
                    text: 'Skip',
                    onPressed: () {
                      setState(() {
                        _skippedToLastPage = true;
                      });
                      _pageController.jumpToPage(2); // Jump to last slide
                    },
                    textColor: grayTextColor,
                    fontSize: 16,
                  )
                : WeightLogTextButton(
                    key: const Key('back_button'),
                    text: 'Back',
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    textColor: grayTextColor,
                    fontSize: 16,
                  ),
          // Next or Get Started button
          isLastPage
              ? WeightLogTextButton(
                  key: const Key('get_started_button'),
                  text: 'Get Started',
                  onPressed: () async {
                    await controller.completeOnboarding();
                    final isLoggedIn =
                        await DailyWeightLogsSecureStorage().isUserLoggedIn();

                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed(
                        isLoggedIn
                            ? MainRoutes.weightLogRoute
                            : InitialRoutes.loginRoute,
                      );
                    }
                  },
                  textColor: secondaryColor,
                  textFontWeight: FontWeight.w600,
                  fontSize: 16,
                )
              : WeightLogTextButton(
                  key: const Key('next_button'),
                  text: 'Next',
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  textColor: secondaryColor,
                  textFontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
        ],
      ),
    );
  }
}
