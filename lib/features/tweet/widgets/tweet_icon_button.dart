// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  final String pathName;
  final String text;
  final VoidCallback onTap;
  const TweetIconButton({
    super.key,
    required this.pathName,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(children: [
        SvgPicture.asset(
          pathName,
          colorFilter: const ColorFilter.mode(
            Pallete.greyColor,
            BlendMode.srcIn,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(6),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ]),
    );
  }
}
