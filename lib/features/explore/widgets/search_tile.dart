import 'package:flutter/material.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModer;
  const SearchTile({super.key, required this.userModer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModer.profilePicture),
        radius: 30,
      ),
      title: Text(
        userModer.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModer.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            userModer.bio,
            style: const TextStyle(
              fontSize: 16,
              color: Pallete.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
