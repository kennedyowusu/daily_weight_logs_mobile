import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_button_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: authState.when(
        data: (authResponse) {
          if (authResponse != null && authResponse.token != null) {
            return Center(child: Text('Welcome, ${authResponse.user?.name}!'));
          }
          return RegisterForm();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
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
                hintText: 'Enter your full name',
                labelText: 'Full Name',
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
                hintText: 'Enter your username',
                labelText: 'Username',
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
                hintText: 'Enter your email',
                labelText: 'Email',
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
                hintText: 'Enter your country',
                labelText: 'Country',
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
                hintText: 'Enter your password',
                labelText: 'Password',
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off),
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
                hintText: 'Confirm your password',
                labelText: 'Confirm Password',
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off),
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
              const SizedBox(height: 24),

              // Register Button
              WeightLogButton(
                text: 'Create Account',
                buttonTextColor: Colors.white,
                isEnabled: true,
                key: const Key('register_button'),
                onPressed: () async {
                  if (formKey.currentState?.validate() == true) {
                    await ref.read(authControllerProvider.notifier).register(
                          nameController.text.trim(),
                          usernameController.text.trim(),
                          emailController.text.trim(),
                          countryController.text.trim(),
                          passwordController.text.trim(),
                          confirmPasswordController.text.trim(),
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
            ],
          ),
        ),
      ),
    );
  }
}
