import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/view/tweet_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/carousel_image.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:timeago/timeago.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    TweetReplyScreen.route(tweet),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                UserProfileView.route(user),
                              ),
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profilePicture),
                                radius: 35,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tweet.retweetedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        colorFilter: const ColorFilter.mode(
                                          Pallete.greyColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${user.name} retweeted',
                                        style: const TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '@${user.name} - ${format(tweet.tweetedAt, locale: 'en_short')}',
                                      style: const TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                if (tweet.repliedTo.isNotEmpty)
                                  ref
                                      .watch(getTweetByIDProvider(tweet.id))
                                      .when(
                                        data: (data) {
                                          final usr = ref
                                              .watch(
                                                  userDetailsProvider(data.uid))
                                              .value;
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Replying to ',
                                              style: const TextStyle(
                                                color: Pallete.greyColor,
                                                fontSize: 16,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '@${usr?.name}',
                                                  style: const TextStyle(
                                                    color: Pallete.blueColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (er, st) => ErrorText(
                                          error: er.toString(),
                                        ),
                                        loading: () => const SizedBox(),
                                      ),
                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image)
                                  CarouselImage(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: AnyLinkPreview(
                                      link: 'https://${tweet.link}',
                                      displayDirection:
                                          UIDirection.uiDirectionHorizontal,
                                    ),
                                  ),
                                ],
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TweetIconButton(
                                        pathName: AssetsConstants.viewsIcon,
                                        text: (tweet.commentIDs.length +
                                                tweet.reshareCount +
                                                tweet.likes.length)
                                            .toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetsConstants.commentIcon,
                                        text:
                                            tweet.commentIDs.length.toString(),
                                        onTap: () {},
                                      ),
                                      TweetIconButton(
                                        pathName: AssetsConstants.retweetIcon,
                                        text: tweet.reshareCount.toString(),
                                        onTap: () {
                                          ref
                                              .read(
                                                tweetControllerProvider
                                                    .notifier,
                                              )
                                              .reshareTweet(
                                                context,
                                                tweet,
                                                currentUser,
                                              );
                                        },
                                      ),
                                      LikeButton(
                                        size: 25,
                                        likeBuilder: (isLiked) => isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Pallete.redColor,
                                                  BlendMode.srcIn,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants
                                                    .likeOutlinedIcon,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Pallete.greyColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                        isLiked: tweet.likes
                                            .contains(currentUser.uid),
                                        likeCount: tweet.likes.length,
                                        onTap: (isLiked) async {
                                          ref
                                              .watch(tweetControllerProvider
                                                  .notifier)
                                              .likeTweet(tweet, currentUser);
                                          return !isLiked;
                                        },
                                        countBuilder:
                                            (likeCount, isLiked, text) =>
                                                Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Pallete.redColor
                                                  : Pallete.whiteColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share_outlined,
                                          size: 25,
                                          color: Pallete.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        color: Pallete.greyColor,
                      )
                    ],
                  ),
                );
              },
              error: ((error, stackTrace) =>
                  ErrorText(error: error.toString())),
              loading: () => const Loader(),
            );
  }
}
