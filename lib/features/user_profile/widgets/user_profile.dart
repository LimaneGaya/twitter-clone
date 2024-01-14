import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/widgets/follow_count.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  _getCRUD(String op) =>
      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.$op';
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: user.coverPicture.isEmpty
                            ? Container(color: Pallete.blueColor)
                            : Image.network(user.coverPicture),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 20,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture),
                          radius: 45,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 30,
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                                width: 3,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          onPressed: () {
                            print('something');
                          },
                          child: Text(
                            currentUser == user ? 'Edit Profile' : 'Follow',
                            style: const TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            FollowCount(
                              count: user.following.length,
                              text: 'Following',
                            ),
                            const SizedBox(width: 15),
                            FollowCount(
                              count: user.followers.length,
                              text: 'Followers',
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Divider(color: Pallete.whiteColor),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (qTwts) => ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          final Tweet rtTwt = Tweet.fromMap(data.payload);
                          final bool notInList = !qTwts.contains(rtTwt);
                          if (notInList && rtTwt.uid == user.uid) {
                            if (data.events.contains(_getCRUD('create'))) {
                              qTwts.insert(0, rtTwt);
                            } else if (data.events
                                .contains(_getCRUD('update'))) {
                              final t =
                                  qTwts.firstWhere((twt) => twt.id == rtTwt.id);
                              qTwts[qTwts.indexOf(t)] = rtTwt;
                            }
                          }

                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = qTwts[index];
                              return TweetCard(tweet: tweet);
                            },
                            itemCount: qTwts.length,
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = qTwts[index];
                              return TweetCard(tweet: tweet);
                            },
                            itemCount: qTwts.length,
                          );
                        },
                      ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          );
  }
}
