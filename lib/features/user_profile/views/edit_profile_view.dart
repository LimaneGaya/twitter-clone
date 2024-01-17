import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/storage_api.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/core/utils.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:twitter_clone/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const EditProfileView(),
      );
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  File? coverImage;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    nameController.text =
        ref.read(currentUserDetailsProvider).value?.name ?? '';
    bioController.text = ref.read(currentUserDetailsProvider).value?.bio ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void selectCoverPicture() async {
    final cover = await pickImage();
    if (mounted && cover != null) {
      setState(() {
        coverImage = cover;
      });
    }
  }

  void selectProfilePicture() async {
    final profile = await pickImage();
    if (mounted && profile != null) {
      setState(() {
        profileImage = profile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return isLoading || user == null
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    ref
                        .read(userProfileControllerProvider.notifier)
                        .updateUserProfile(
                          context: context,
                          model: user.copyWith(
                            name: nameController.text,
                            bio: bioController.text,
                          ),
                          profileFile: profileImage,
                          coverFile: coverImage,
                        );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectCoverPicture,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: coverImage != null
                              ? Image.file(coverImage!, fit: BoxFit.fitWidth)
                              : user.coverPicture.isEmpty
                                  ? Container(color: Pallete.blueColor)
                                  : Hero(
                                      tag: 'coverPic',
                                      child: Image.network(
                                        user.coverPicture,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfilePicture,
                          child: profileImage != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(profileImage!),
                                  radius: 40)
                              : Hero(
                                  tag: 'profilePic',
                                  child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.profilePicture),
                                      radius: 40),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    hintText: 'Bio',
                    contentPadding: EdgeInsets.all(20),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          );
  }
}
