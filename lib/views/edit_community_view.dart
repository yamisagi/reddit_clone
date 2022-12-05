// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/util/common/pick_image.dart';
import 'package:reddit_clone/util/edit_community_view/avatar_picker.dart';
import 'package:reddit_clone/util/edit_community_view/banner_picker.dart';

class EditCommunityView extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityView({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityViewState();
}

class _EditCommunityViewState extends ConsumerState<EditCommunityView> {
  File? bannerImage;
  File? avatarImage;
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

  void saveChanges(CommunityModel communityModel) async {
    ref.read(communityControllerProvider.notifier).editCommunity(
          community: communityModel,
          bannerImage: bannerImage,
          avatarImage: avatarImage,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ref.watch(getCommunityByNameProvider(widget.name)).when(
              error: (error, stackTrace) => const Center(
                child: Text('Something went wrong'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              data: (community) {
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    title: const Text('Edit Community'),
                    actions: [
                      TextButton.icon(
                        label: const Text('Save'),
                        onPressed: () => saveChanges(community),
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
                              BannerPicker(
                                func: selectBannerImage,
                                community: community,
                                bannerImage: bannerImage,
                              ),
                              AvatarPicker(
                                func: selectAvatarImage,
                                community: community,
                                avatarImage: avatarImage,
                              ),
                            ],
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
