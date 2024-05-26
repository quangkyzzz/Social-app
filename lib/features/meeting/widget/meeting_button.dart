import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';

class MeetingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  const MeetingButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                color: Pallete.blueColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Pallete.backgroundColor.withOpacity(0.06),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Pallete.whiteColor,
                    fontSize: 20,
                  ),
                ),
              )),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}
