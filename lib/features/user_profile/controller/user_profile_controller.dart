import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/models/tweet_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileNotifier, bool>(
  (ref) => UserProfileNotifier(tweetAPI: ref.watch(tweetAPIProvider)),
);

final getUserTweetsProvider = FutureProvider.family(
  (ref, String uid) =>
      ref.watch(userProfileControllerProvider.notifier).getUserTweets(uid),
);

class UserProfileNotifier extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  UserProfileNotifier({
    required TweetAPI tweetAPI,
  })  : _tweetAPI = tweetAPI,
        super(false);
  Future<List<Tweet>> getUserTweets(String uid) async {
    return await _tweetAPI.getUserTweets(uid).then(
          (tweets) => tweets.map((e) => Tweet.fromMap(e.data)).toList(),
        );
  }
}
