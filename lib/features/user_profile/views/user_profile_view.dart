import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/features/user_profile/widgets/user_profile.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
      builder: (context) => UserProfileView(userModel: userModel));
  final UserModel userModel;
  const UserProfileView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel user = userModel;
    return Scaffold(
      body: ref.watch(getLatestTweetProvider).when(
          data: (data) {
            if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${userModel.uid}.update')) {
              user = UserModel.fromMap(data.payload);
            }
            return UserProfile(user: user);
          },
          error: ((error, stackTrace) => ErrorText(error: error.toString())),
          loading: () => UserProfile(user: user)),
    );
  }
}
