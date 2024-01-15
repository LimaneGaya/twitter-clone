import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileNotifier, bool>(
  (ref) => UserProfileNotifier(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  ),
);

final getUserTweetsProvider = FutureProvider.family(
  (ref, String uid) =>
      ref.watch(userProfileControllerProvider.notifier).getUserTweets(uid),
);

class UserProfileNotifier extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  UserProfileNotifier({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);
  Future<List<Tweet>> getUserTweets(String uid) async {
    return await _tweetAPI.getUserTweets(uid).then(
          (tweets) => tweets.map((e) => Tweet.fromMap(e.data)).toList(),
        );
  }

  Future<void> updateUserProfile({
    required BuildContext context,
    required UserModel model,
    required File? profileFile,
    required File? coverFile,
  }) async {
    state = true;
    if (profileFile != null) {
      final profileURL = await _storageAPI.uploadImages([profileFile]);
      model = model.copyWith(profilePicture: profileURL.first);
    }
    if (coverFile != null) {
      final coverURL = await _storageAPI.uploadImages([coverFile]);
      model = model.copyWith(coverPicture: coverURL.first);
    }
    final res = await _userAPI.updateUserData(model);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }
}
