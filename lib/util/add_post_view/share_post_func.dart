import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/util/common/snackbar.dart';

Future<void> sharePost(
  BuildContext context,
  WidgetRef ref, {
  String? type,
  File? bannerImage,
  Uint8List? bannerWebFile,
  required CommunityModel? selectedCommunity,
  required TextEditingController titleController,
  required TextEditingController bodyController,
  required TextEditingController linkController,
  required List<CommunityModel> communities,
}) async {
  if (type == 'image' &&
      (bannerImage != null || bannerWebFile != null) &&
      titleController.text.isNotEmpty) {
    await ref.read(postControllerProvider.notifier).postImage(
          webFile: bannerWebFile,
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities.first,
          image: bannerImage,
        );
  } else if (type == 'text' && titleController.text.isNotEmpty) {
    await ref.read(postControllerProvider.notifier).postText(
          context: context,
          title: titleController.text.trim(),
          description: bodyController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities.first,
        );
  } else if (type == 'link' &&
      titleController.text.isNotEmpty &&
      linkController.text.isNotEmpty) {
    await ref.read(postControllerProvider.notifier).postLink(
          context: context,
          title: titleController.text.trim(),
          link: linkController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities.first,
        );
  } else {
    showSnackBar(
        context,
        'Something went wrong',
        ref.read(
          scaffoldMessengerKeyProvider,
        ));
  }
}
