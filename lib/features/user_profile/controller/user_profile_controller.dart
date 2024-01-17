import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/apis/tweet_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/core/enums/notification_type_enum.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/notification/controller/notification_controller.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileNotifier, bool>(
  (ref) => UserProfileNotifier(
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
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
  final NotificationController _notificationController;
  UserProfileNotifier({
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
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

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    if (currentUser.following.contains(user.uid)) {
      user.followers.remove(currentUser.uid);
      currentUser.following.remove(user.uid);
    } else {
      user.followers.add(currentUser.uid);
      currentUser.following.add(user.uid);
    }
    final ref = await _userAPI.updateUserFollowsData(user);
    ref.fold((l) => showSnackBar(context, l.message), (r) async {
      final res = await _userAPI.updateUserFollowsData(currentUser);
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) async {
          await _notificationController.createNotification(
            text: '${currentUser.name} followed you',
            postID: '',
            type: NotificationType.follow,
            uid: user.uid,
          );
        },
      );
    });
  }
}
