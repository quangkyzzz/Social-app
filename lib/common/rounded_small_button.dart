import 'package:demo_x/theme/theme.dart';
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backGroundColor;
  final Color textColor;

  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backGroundColor = Pallete.blackColor,
    this.textColor = Pallete.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
        ),
        backgroundColor: backGroundColor,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
  }
}
