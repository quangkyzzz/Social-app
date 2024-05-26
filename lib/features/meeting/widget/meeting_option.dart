import 'package:demo_x/theme/pallete.dart';
import 'package:flutter/material.dart';

class MeetingOption extends StatelessWidget {
  final String text;
  final bool isMuted;
  final Function(bool) onChange;

  const MeetingOption(
      {super.key,
      required this.text,
      required this.isMuted,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Pallete.backgroundGreyColor,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Switch(value: isMuted, onChanged: onChange)
        ],
      ),
    );
  }
}
