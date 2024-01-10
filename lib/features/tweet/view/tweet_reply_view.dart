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
  _getCRUD(String op) =>
      'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.$op';
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
                data: (qTwts) => ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final Tweet rtTwt = Tweet.fromMap(data.payload);
                        final bool isInList = !qTwts.contains(rtTwt);
                        if (isInList && data.payload['repliedTo'] == tweet.id) {
                          if (data.events.contains(_getCRUD('create'))) {
                            qTwts.insert(0, rtTwt);
                          } else if (data.events.contains(_getCRUD('update'))) {
                            final t =
                                qTwts.firstWhere((twt) => twt.id == rtTwt.id);
                            qTwts[qTwts.indexOf(t)] = rtTwt;
                          }
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemBuilder: ((BuildContext context, int index) {
                              final tweet = qTwts[index];
                              return TweetCard(tweet: tweet);
                            }),
                            itemCount: qTwts.length,
                          ),
                        );
                      },
                      error: ((error, stackTrace) =>
                          ErrorText(error: error.toString())),
                      loading: () {
                        return Expanded(
                          child: ListView.builder(
                            itemBuilder: ((BuildContext context, int index) {
                              final tweet = qTwts[index];
                              return TweetCard(tweet: tweet);
                            }),
                            itemCount: qTwts.length,
                          ),
                        );
                      },
                    ),
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
