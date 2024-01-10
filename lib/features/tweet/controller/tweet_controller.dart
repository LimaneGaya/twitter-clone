import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) => TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  ),
);
final getTweetsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(tweetControllerProvider.notifier).getTweets(),
);

final getRepliesToTweetProvider = FutureProvider.family(
  (ref, Tweet tweet) =>
      ref.watch(tweetControllerProvider.notifier).getRepliesToTweet(tweet),
);

final getLatestTweetProvider = StreamProvider.autoDispose(
  (ref) => ref.watch(tweetAPIProvider).getLatestTweet(),
);

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController(
      {required Ref ref,
      required TweetAPI tweetAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<void> shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }
    if (images.isNotEmpty) {
      await _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    } else {
      await _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
      );
    }
  }

  Future<void> _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    List<String> imageLinks;
    try {
      imageLinks = await _storageAPI.uploadImages(images);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
      state = false;
      return;
    }
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: imageLinks,
        uid: user.uid,
        tweetType: TweetType.image,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIDs: const [],
        id: '',
        reshareCount: 0,
        retweetedBy: '',
        repliedTo: repliedTo);
    final response = await _tweetAPI.shareTweet(tweet);
    state = false;
    response.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Future<void> _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    final link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIDs: const [],
      id: '',
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final response = await _tweetAPI.shareTweet(tweet);
    state = false;
    response.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentese = text.split(' ');
    for (String word in wordsInSentese) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentese = text.split(' ');
    for (String word in wordsInSentese) {
      word = word.trim();
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) => null);
  }

  void reshareTweet(
    BuildContext context,
    Tweet tweet,
    UserModel currentUser,
  ) async {
    tweet = tweet.copyWith(reshareCount: tweet.reshareCount + 1);
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        tweet = tweet.copyWith(
          retweetedBy: currentUser.name,
          likes: [],
          commentIDs: [],
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) => showSnackBar(context, 'Retweeted'),
        );
      },
    );
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final document = await _tweetAPI.getRepliesToTweet(tweet);
    return document.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
