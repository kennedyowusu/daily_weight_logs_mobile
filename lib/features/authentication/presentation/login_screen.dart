import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/utils/secure_storage.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_loading_dialog.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/application/auth_controller.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_button_text.dart';
import 'package:daily_weight_logs_mobile/features/authentication/widgets/weight_log_input_field.dart';
import 'package:daily_weight_logs_mobile/router/unauthenticated_routes.dart';
import 'package:daily_weight_logs_mobile/router/authenticated_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            const WeightLogText(
              text: 'Welcome back!',
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
            // Password Field
            WeightLogInputField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Enter your password',
              labelText: 'Password',
              obscureText: true,
              inputTextColor: secondaryColor,
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
            const SizedBox(height: 24),
            // Forget password
            Align(
              alignment: Alignment.centerRight,
              child: WeightLogText(
                text: 'Forgot your password?',
                color: grayTextColor,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    InitialRoutes.forgotPasswordRoute,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // WeightLogButton(
            //   text: 'Login to your Account',
            //   buttonTextColor: Colors.white,
            //   isEnabled: true,
            //   key: const Key('login_button'),
            //   onPressed: () async {
            //     if (formKey.currentState?.validate() == true) {
            //       // Show loading dialog
            //       showDialog(
            //         context: context,
            //         barrierDismissible: false,
            //         barrierColor: Colors.black.withOpacity(0.5),
            //         useSafeArea: true,
            //         builder: (BuildContext context) {
            //           return const WeightLogLoadingDialog(
            //               message: 'Logging in...');
            //         },
            //       );

            //       // Call login API
            //       await ref.read(authControllerProvider.notifier).login(
            //             emailController.text.trim(),
            //             passwordController.text.trim(),
            //           );

            //       // Dismiss the loading dialog
            //       Navigator.of(context).pop();

            //       // Handle login response
            //       final authState = ref.watch(authControllerProvider);
            //       authState.when(
            //         data: (response) {
            //           if (response?.token != null) {
            //             // Dismiss loading dialog
            //             Navigator.of(context).pop();

            //             // Navigate to the next screen
            //             Navigator.pushReplacementNamed(
            //               context,
            //               MainRoutes.heightLogRoute,
            //             );
            //           } else {
            //             // Dismiss loading dialog and show error
            //             Navigator.of(context).pop();
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 content: Text(
            //                     response?.message ?? 'Unknown error occurred'),
            //                 backgroundColor: Colors.red,
            //               ),
            //             );
            //           }
            //         },
            //         loading: () {
            //           // Loading state is handled by the dialog
            //         },
            //         error: (error, stackTrace) {
            //           // Dismiss loading dialog and show error
            //           Navigator.of(context).pop();
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(
            //               content: Text(error.toString()),
            //               backgroundColor: Colors.red,
            //             ),
            //           );
            //         },
            //       );
            //     }
            //   },
            // ),

            WeightLogButton(
              text: 'Login to your Account',
              buttonTextColor: Colors.white,
              isEnabled: true,
              key: const Key('login_button'),
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
                          message: 'Logging in...');
                    },
                  );

                  // Call login API
                  final authResponse = await ref
                      .read(authControllerProvider.notifier)
                      .login(emailController.text.trim(),
                          passwordController.text.trim());

                  // Dismiss the loading dialog
                  Navigator.of(context).pop();

                  if (authResponse?.token != null) {
                    // Store the access token
                    await DailyWeightLogsSecureStorage()
                        .storeAccessToken(authResponse!.token!);

                    // Navigate to the WeightLogScreen
                    if (mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        MainRoutes.weightLogRoute,
                      );
                    }
                  } else {
                    // Show error message if login fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          authResponse?.message ?? 'Unknown error occurred',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 16),
            const WeightLogButtonText(
              mainText: 'Don\'t have an account? ',
              actionText: 'Sign up',
              route: InitialRoutes.registerRoute,
            ),
          ],
        ),
      ),
    );
  }
}
