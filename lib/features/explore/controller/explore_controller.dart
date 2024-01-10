import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

class ExploreNotifier extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreNotifier({
    required UserAPI userAPI,
  })  : _userAPI = userAPI,
        super(false);
  Future<List<UserModel>> getUser(String name) async {
    return await _userAPI.searchUserByName(name).then(
          (docs) => docs.map((e) => UserModel.fromMap(e.data)).toList(),
        );
  }
}
