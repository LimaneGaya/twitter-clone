import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/theme.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color backgroundColor;
  final Color fontColor;

  const RoundedSmallButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor = Pallete.whiteColor,
    this.fontColor = Pallete.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        ),
        backgroundColor: MaterialStatePropertyAll(backgroundColor),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: fontColor, fontSize: 16),
      ),
    );
  }
}
