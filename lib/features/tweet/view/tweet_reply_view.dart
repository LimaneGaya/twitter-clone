import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';
import 'package:twitter_clone/models/tweet_model.dart';

class TweetReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: ((context) => TweetReplyScreen(tweet: tweet)),
      );

  final Tweet tweet;
  const TweetReplyScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replies'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestRepliesProvider(tweet.id)).when(
                        data: (data) {
                          if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create')) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update')) {
                            final newTweet = Tweet.fromMap(data.payload);
                            final tweet = tweets.firstWhere(
                                (oldTweet) => oldTweet.id == newTweet.id);
                            tweets[tweets.indexOf(tweet)] = newTweet;
                          }
                          return Expanded(
                            child: ListView.builder(
                              itemBuilder: ((BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                              itemCount: tweets.length,
                            ),
                          );
                        },
                        error: ((error, stackTrace) =>
                            ErrorText(error: error.toString())),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemBuilder: ((BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              }),
                              itemCount: tweets.length,
                            ),
                          );
                        },
                      );
                },
                error: ((error, stackTrace) =>
                    ErrorText(error: error.toString())),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) =>
            ref.watch(tweetControllerProvider.notifier).shareTweet(
          images: [],
          text: value,
          context: context,
          repliedTo: tweet.id,
        ),
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}