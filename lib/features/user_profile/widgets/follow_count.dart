import 'package:flutter/material.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({
    super.key,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        '$count',
        style: const TextStyle(),
      ),
    ]);
  }
}
