import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/features/user_profile/views/edit_profile_view.dart';
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
                            : Hero(
                                tag: 'coverPic',
                                child: Image.network(
                                  user.coverPicture,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 20,
                        child: Hero(
                          tag: 'profilePic',
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture),
                            radius: 45,
                          ),
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
                            if (currentUser.uid == user.uid) {
                              Navigator.of(context).push(
                                EditProfileView.route(),
                              );
                            } else {
                              ref
                                  .read(userProfileControllerProvider.notifier)
                                  .followUser(
                                    user: user,
                                    context: context,
                                    currentUser: currentUser,
                                  );
                            }
                          },
                          child: Text(
                            currentUser.uid == user.uid
                                ? 'Edit Profile'
                                : currentUser.following.contains(user.uid)
                                    ? 'Unfollow'
                                    : 'Follow',
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                ),
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
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
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (user.isTwitterBlue)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: SvgPicture.asset(
                                  AssetsConstants.verifiedIcon,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                          ],
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
                          if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents')) {
                            final Tweet rtTwt = Tweet.fromMap(data.payload);
                            final bool notInList = !qTwts.contains(rtTwt);
                            if (notInList && rtTwt.uid == user.uid) {
                              if (data.events.contains(_getCRUD('create'))) {
                                qTwts.insert(0, rtTwt);
                              } else if (data.events
                                  .contains(_getCRUD('update'))) {
                                final t = qTwts
                                    .firstWhere((twt) => twt.id == rtTwt.id);
                                qTwts[qTwts.indexOf(t)] = rtTwt;
                              }
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
