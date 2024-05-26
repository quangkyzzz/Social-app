import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:demo_x/features/auth/widgets/auth_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:demo_x/common/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/pallete.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final appbar = UIConstants.appBar();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogIn() {
    ref.read(authControllerProvider.notifier).logIn(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appbar,
      body: isLoading
          ? const LoadingPage()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AuthField(
                        controller: emailController,
                        hintText: 'Email',
                        hideText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AuthField(
                        controller: passwordController,
                        hintText: 'Password',
                        hideText: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedSmallButton(
                        onTap: onLogIn,
                        label: 'Login',
                        textColor: Pallete.blackColor,
                        backGroundColor: Pallete.whiteColor,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' Sign up',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed('/sign-up/');
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
