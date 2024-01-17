import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/views/user_profile_view.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_Controller.dart';

import 'package:twitter_clone/theme/theme.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});
  ListTile button(IconData icon, String text, VoidCallback func) => ListTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          text,
          style: const TextStyle(fontSize: 22),
        ),
        onTap: func,
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : SafeArea(
            child: Drawer(
              backgroundColor: Pallete.backgroundColor,
              child: ListView(
                children: [
                  const SizedBox(height: 70),
                  button(Icons.person, 'My Profile', () {
                    Navigator.push(context, UserProfileView.route(currentUser));
                  }),
                  button(
                    Icons.payment,
                    'Twitter Blue',
                    () {
                      ref
                          .read(userProfileControllerProvider.notifier)
                          .updateUserProfile(
                            context: context,
                            model: currentUser.copyWith(isTwitterBlue: true),
                            profileFile: null,
                            coverFile: null,
                          );
                    },
                  ),
                  button(Icons.logout, 'Log Out', () {
                    ref.read(authControllerProvider.notifier).logout(context);
                  }),
                ],
              ),
            ),
          );
  }
}
