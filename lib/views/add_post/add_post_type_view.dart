// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/add_post_view/share_post_func.dart';
import 'package:reddit_clone/util/common/pick_image.dart';
import 'package:reddit_clone/util/post/post_image_widget.dart';
import 'package:reddit_clone/util/post/post_text_widget.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';

class AddPostTypeView extends ConsumerStatefulWidget {
  // We will use for every type of post (image, text, link) the same view
  // But first we need to know what type of post we are going to create

  final String type;

  const AddPostTypeView({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeViewState();
}

class _AddPostTypeViewState extends ConsumerState<AddPostTypeView> {
  File? bannerImage;
  Uint8List? bannerWebFile;
  List<CommunityModel> communities = [];
  CommunityModel? selectedCommunity;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _linkController = TextEditingController();
  }

  @override
  void deactivate() {
    _titleController.dispose();
    _bodyController.dispose();
    _linkController.dispose();
    super.deactivate();
  }

  Future<void> selectBannerImage() async {
    final banner = await pickImage();

    if (banner != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = banner.files.first.bytes;
        });
      }

      setState(() {
        bannerImage = File(banner.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton.icon(
            label: const Text('Post'),
            onPressed: () async {
              await sharePost(
                context,
                ref,
                selectedCommunity: selectedCommunity,
                titleController: _titleController,
                bodyController: _bodyController,
                linkController: _linkController,
                communities: communities,
                bannerImage: bannerImage,
                bannerWebFile: bannerWebFile,
                type: widget.type,
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ResponsiveWidget(
          child: Column(
            children: [
              Padding(
                padding: Constants.regularPadding,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: Constants.regularPadding,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              if (isTypeImage)
                PostImageWidget(
                  bannerWebFile: bannerWebFile,
                  currentTheme: currentTheme.themeMode,
                  bannerImage: bannerImage,
                  onTap: () async {
                    await selectBannerImage();
                  },
                ),
              if (isTypeText)
                PostTextWidget(
                  currentTheme: currentTheme,
                  bodyController: _bodyController,
                ),
              if (isTypeLink)
                Padding(
                  padding: Constants.regularPadding,
                  child: TextField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Link',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: Constants.regularPadding,
                    ),
                  ),
                ),
              Padding(
                padding: Constants.regularPadding,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Select Community',
                    style: Theme.of(context) //
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              ref.watch(userCommunitiesProvider).when(
                    error: (error, stack) => Center(
                      child: Text('Error $error'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    data: (data) {
                      communities = data;
                      if (data.isEmpty) {
                        return const Center(
                          child: Text('No communities'),
                        );
                      }
                      return DropdownButton(
                        value: selectedCommunity ?? data[0],
                        items: data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.communityName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCommunity = value;
                          });
                        },
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
