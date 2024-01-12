import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/loading_page.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: user.coverPicture.isEmpty
                            ? Container(color: Pallete.blueColor)
                            : Image.network(user.coverPicture),
                      ),
                      Positioned(
                        bottom: -20,
                        left: 20,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicture),
                          radius: 45,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 30,
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Pallete.whiteColor,
                                width: 3,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          onPressed: () {
                            print('something');
                          },
                          child: Text(
                            currentUser == user ? 'Edit Profile' : 'Follow',
                            style: const TextStyle(color: Pallete.whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Pallete.greyColor,
                          ),
                        ),
                        Text(
                          user.bio,
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: Container(),
          );
  }
}
