// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class UserAvatarPicker extends StatelessWidget {
  const UserAvatarPicker({
    Key? key,
    required this.func,
    required this.user,
    required this.avatarWebFile,
    this.avatarImage,
  }) : super(key: key);
  final VoidCallback func;
  final UserModel user;
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
          : MediaQuery.of(context).size.height * 0.15,
      child: GestureDetector(
        onTap: func,
        child: avatarWebFile != null
            ? CircleAvatar(
                backgroundColor: ColorPallete.lightGreyColor,
                radius: kIsWeb
                    ? MediaQuery.of(context).size.height * 0.04
                    : MediaQuery.of(context).size.width * 0.01,
                backgroundImage: MemoryImage(avatarWebFile!),
              )
            : avatarImage != null
                ? CircleAvatar(
                    backgroundColor: ColorPallete.lightGreyColor,
                    radius: kIsWeb
                        ? MediaQuery.of(context).size.height * 0.04
                        : MediaQuery.of(context).size.width * 0.01,
                    backgroundImage: FileImage(avatarImage!),
                  )
                : CircleAvatar(
                    backgroundColor: ColorPallete.lightGreyColor,
                    radius: kIsWeb
                        ? MediaQuery.of(context).size.height * 0.04
                        : MediaQuery.of(context).size.width * 0.01,
                    backgroundImage: NetworkImage(user.profilePic),
                  ),
      ),
    );
  }
}
