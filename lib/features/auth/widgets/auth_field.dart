import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool hideText;
  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.hideText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: hideText,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Pallete.blueColor,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 20),
        contentPadding: const EdgeInsets.all(22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 2,
            color: Pallete.greyColor,
          ),
        ),
      ),
    );
  }
}
