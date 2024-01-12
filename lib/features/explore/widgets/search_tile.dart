import 'package:flutter/material.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(UserProfileView.route(userModel));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(userModel.profilePicture),
        radius: 30,
      ),
      title: Text(
        userModel.name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            userModel.bio,
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
