import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: authState.when(
        data: (_) => ForgotPasswordForm(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class ForgotPasswordForm extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            const WeightLogText(
              text: 'Reset your password',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
            Image.asset(
              weightLogoPng,
              width: 150,
              height: 150,
            ),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.14),

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
            const SizedBox(height: 24),
            // Submit Button
            WeightLogButton(
              text: 'Send Reset Link',
              buttonTextColor: Colors.white,
              isEnabled: true,
              key: const Key('reset_password_button'),
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  await ref
                      .read(authControllerProvider.notifier)
                      .forgotPassword(
                        emailController.text.trim(),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset link sent to your email'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            // Navigate to Login Button
            Align(
              alignment: Alignment.center,
              child: WeightLogText(
                text: 'Remember your password? ',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    InitialRoutes.loginRoute,
                  );
                },
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
