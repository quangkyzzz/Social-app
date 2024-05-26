import 'package:demo_x/features/auth/controller/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:demo_x/common/common.dart';
import '../../../theme/pallete.dart';
import '../widgets/auth_field.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final appbar = UIConstants.appBar();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
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
          ? const Loader()
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
                        onTap: () => onSignUp(),
                        label: 'Sign Up',
                        textColor: Pallete.blackColor,
                        backGroundColor: Pallete.whiteColor,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: ' Login',
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed('/login/');
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
