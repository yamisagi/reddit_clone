// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/profile/controller/profile_controller.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/common/pick_image.dart';
import 'package:reddit_clone/util/profile_edit_view/user_avatar_picker.dart';
import 'package:reddit_clone/util/profile_edit_view/user_banner_picker.dart';

class EditProfileView extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileView({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> //
      createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  File? bannerImage;
  File? avatarImage;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(userProvider)?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> selectBannerImage() async {
    final banner = await pickImage();
    if (banner != null) {
      setState(() {
        bannerImage = File(banner.files.first.path!);
      });
    }
  }

  Future<void> selectAvatarImage() async {
    final avatar = await pickImage();
    if (avatar != null) {
      setState(() {
        avatarImage = File(avatar.files.first.path!);
      });
    }
  }

  void saveProfile() {
    ref.read(profileControllerProvider.notifier).editProfile(
          avatarImage: avatarImage,
          bannerImage: bannerImage,
          name: _nameController.text.trim(),
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileControllerProvider);

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ref.watch(getUserDataProvider(widget.uid)).when(
              error: (error, stackTrace) => const Center(
                child: Text('Something went wrong'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (user) {
                return Scaffold(
                  backgroundColor:
                      ref.watch(themeNotifierProvider).scaffoldBackgroundColor,
                  appBar: AppBar(
                    elevation: 0,
                    title: const Text('Edit Profile'),
                    actions: [
                      TextButton.icon(
                        label: const Text('Save'),
                        onPressed: () => saveProfile(),
                        icon: const Icon(Icons.save),
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: Constants.smallPadding,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Stack(
                            children: [
                              UserBannerPicker(
                                bannerImage: bannerImage,
                                user: user,
                                func: () {
                                  selectBannerImage();
                                },
                              ),
                              UserAvatarPicker(
                                func: () {
                                  selectAvatarImage();
                                },
                                user: user,
                                avatarImage: avatarImage,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'New User Name',
                            fillColor: ref
                                        .read(themeNotifierProvider.notifier)
                                        .themeMode ==
                                    ThemeMode.dark
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            filled: true,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
  }
}
