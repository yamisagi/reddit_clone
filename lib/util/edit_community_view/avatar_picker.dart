// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    Key? key,
    required this.func,
    required this.community,
    required this.avatarWebFile,
    this.avatarImage,
  }) : super(key: key);
  final VoidCallback func;
  final CommunityModel community;
  final File? avatarImage;
  final Uint8List? avatarWebFile;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: kIsWeb
          ? MediaQuery.of(context).size.height * 0.05
          : MediaQuery.of(context).size.width * 0.05,
      top: kIsWeb
          ? MediaQuery.of(context).size.height * 0.20
          : MediaQuery.of(context).size.height * 0.22,
      child: GestureDetector(
        onTap: func,
        child: avatarWebFile != null
            ? CircleAvatar(
                backgroundColor: ColorPallete.lightGreyColor,
                radius: kIsWeb
                    ? MediaQuery.of(context).size.height * 0.04
                    : MediaQuery.of(context).size.width * 0.07,
                backgroundImage: MemoryImage(avatarWebFile!),
              )
            : avatarImage != null
                ? CircleAvatar(
                    radius: kIsWeb
                        ? MediaQuery.of(context).size.height * 0.04
                        : MediaQuery.of(context).size.width * 0.07,
                    backgroundImage: FileImage(avatarImage!),
                  )
                : CircleAvatar(
                    radius: kIsWeb
                        ? MediaQuery.of(context).size.height * 0.04
                        : MediaQuery.of(context).size.width * 0.07,
                    backgroundImage: NetworkImage(community.communityAvatar),
                  ),
      ),
    );
  }
}
