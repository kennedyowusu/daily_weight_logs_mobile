import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_loading_dialog.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_button_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State for password visibility
  final bool isPasswordVisible = false;

  RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
              const WeightLogText(
                text: 'Create your Account',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
              Image.asset(
                weightLogoPng,
                width: 150,
                height: 150,
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),

              // Name Field
              WeightLogInputField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                hintText: 'Enter your full name',
                labelText: 'Full Name',
                inputTextColor: secondaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Username Field
              WeightLogInputField(
                controller: usernameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                hintText: 'Enter your username',
                labelText: 'Username',
                inputTextColor: secondaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              WeightLogInputField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your email',
                labelText: 'Email',
                inputTextColor: secondaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Country Field
              WeightLogInputField(
                controller: countryController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                hintText: 'Enter your country',
                labelText: 'Country',
                inputTextColor: secondaryColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              WeightLogInputField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter your password',
                labelText: 'Password',
                inputTextColor: secondaryColor,
                obscureText: !isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              WeightLogInputField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
                inputTextColor: secondaryColor,
                obscureText: !isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                    activeColor: secondaryColor,
                  ),
                  const WeightLogText(
                    text: 'I agree to the ',
                    color: grayTextColor,
                    fontSize: 12,
                  ),
                  WeightLogText(
                    text: 'Terms of Service',
                    fontSize: 12,
                    color: secondaryColor,
                  ),
                  const WeightLogText(
                    text: ' & ',
                    color: grayTextColor,
                  ),
                  WeightLogText(
                    text: 'Privacy Policy',
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Register Button
              WeightLogButton(
                text: 'Create Account',
                buttonTextColor: Colors.white,
                isEnabled: true,
                key: const Key('register_button'),
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.5),
                      useSafeArea: true,
                      builder: (BuildContext context) {
                        return const WeightLogLoadingDialog(
                            message: 'Creating Account...');
                      },
                    );

                    // Call login API
                    await ref.read(authControllerProvider.notifier).register(
                          nameController.text.trim(),
                          usernameController.text.trim(),
                          emailController.text.trim(),
                          countryController.text.trim(),
                          passwordController.text.trim(),
                          confirmPasswordController.text.trim(),
                        );

                    // Handle login response
                    final authState = ref.watch(authControllerProvider);
                    authState.when(
                      data: (response) {
                        if (response?.token != null) {
                          // Dismiss loading dialog
                          Navigator.of(context).pop();

                          // Navigate to the next screen
                          Navigator.pushReplacementNamed(
                            context,
                            MainRoutes.heightLogRoute,
                          );
                        } else {
                          // Dismiss loading dialog and show error
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response?.message ??
                                  'Unknown error occurred'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      loading: () {
                        // Loading state is handled by the dialog
                      },
                      error: (error, stackTrace) {
                        // Dismiss loading dialog and show error
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                    );
                  }
                },
              ),

              const SizedBox(height: 16),

              // Navigate to Login
              const WeightLogButtonText(
                mainText: 'Already have an account? ',
                actionText: 'Sign in',
                route: InitialRoutes.loginRoute,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
