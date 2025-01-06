import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_app_bar.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_loading_dialog.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/profile/application/controller/user_profile_controller.dart';
import 'package:daily_weight_logs_mobile/features/profile/widgets/profile_field.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch user profile
      ref.read(userProfileControllerProvider.notifier).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileState = ref.watch(userProfileControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: WeightLogAppBar(
          fontSize: 20,
          titleText: 'Profile Settings',
          backgroundColor: secondaryColor,
          textColor: Colors.white,
          automaticallyImplyLeading: true,
        ),
      ),
      body: userProfileState.when(
        data: (userProfile) {
          if (userProfile == null) {
            return const Center(
              child: Text(
                'No profile data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 60,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 58,
                      backgroundImage: AssetImage(weightLogoPng),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name and Username
                  Column(
                    children: [
                      Text(
                        userProfile.name ?? 'Unknown Name',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${userProfile.username ?? 'username'}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Profile Fields
                  ProfileField(
                    label: 'Country',
                    value: userProfile.country ?? 'Unknown Country',
                    isEditable: true,
                  ),
                  ProfileField(
                    label: 'Email',
                    value: userProfile.email ?? 'Unknown Email',
                    isEditable: false,
                  ),
                  ProfileField(
                    label: 'Joined',
                    value: userProfile.createdAt != null
                        ? DateFormat('d MMM yyyy')
                            .format(userProfile.createdAt!)
                        : 'Unknown Date',
                    isEditable: false,
                  ),

                  // Log Out Button
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: WeightLogButton(
                      buttonBackgroundColor: primaryColor,
                      buttonTextColor: secondaryColor,
                      buttonTextFontWeight: FontWeight.bold,
                      isEnabled: true,
                      onPressed: () async {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return const WeightLogLoadingDialog(
                              message: 'Logging out...',
                            );
                          },
                        );

                        // Call logout method
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();

                        // Close the loading dialog after logout completes
                        Navigator.of(context).pop();

                        // Navigate to login screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          InitialRoutes.loginRoute,
                          (route) => false, // Remove all previous routes
                        );
                      },
                      text: 'Logout from Account',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Delete Account Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: WeightLogButton(
                      buttonBackgroundColor: Colors.red,
                      buttonTextColor: Colors.white,
                      buttonTextFontWeight: FontWeight.bold,
                      isEnabled: true,
                      onPressed: () async {
                        // Show confirmation dialog
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: WeightLogText(
                              text: 'Delete Account',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.withOpacity(0.6),
                              textAlign: TextAlign.center,
                            ),
                            content: const WeightLogText(
                              text:
                                  'Are you sure you want to delete your account? This action cannot be undone.',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: WeightLogText(
                                  text: 'Cancel',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: WeightLogText(
                                  text: 'Delete',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: grayTextColor,
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          // Call the delete account method
                          await ref
                              .read(userProfileControllerProvider.notifier)
                              .deleteUserAccount();

                          // Redirect to login screen
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            InitialRoutes.loginRoute,
                            (route) => false, // Remove all previous routes
                          );
                        }
                      },
                      text: 'Delete Account',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        // Loading state

        loading: () => const Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
