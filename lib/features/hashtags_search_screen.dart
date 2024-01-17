import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

class SearchHastagView extends ConsumerWidget {
  static route(String hash) =>
      MaterialPageRoute(builder: (context) => SearchHastagView(hash));
  final String hashtag;
  const SearchHastagView(this.hashtag, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Searching $hashtag')),
      body: ref.watch(getHashtagTweetsProvider(hashtag)).when(
            data: (tweets) {
              return ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, idx) {
                  final tweet = tweets[idx];
                  return TweetCard(tweet: tweet);
                },
              );
            },
            error: (er, st) => ErrorText(error: er.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
