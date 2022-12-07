// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class UserAvatarPicker extends StatelessWidget {
  const UserAvatarPicker({
    Key? key,
    required this.func,
    required this.user,
    this.avatarImage,
  }) : super(key: key);
  final VoidCallback func;
  final UserModel user;
  final File? avatarImage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.05,
      top: MediaQuery.of(context).size.height * 0.15,
      child: GestureDetector(
        onTap: func,
        child: avatarImage != null
            ? CircleAvatar(
                backgroundColor: ColorPallete.lightGreyColor,
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: FileImage(avatarImage!),
              )
            : CircleAvatar(
                backgroundColor: ColorPallete.lightGreyColor,
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: NetworkImage(user.profilePic),
              ),
      ),
    );
  }
}
