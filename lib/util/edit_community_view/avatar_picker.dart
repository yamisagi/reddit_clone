// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:reddit_clone/models/community_model.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    Key? key,
    required this.func,
    required this.community,
    this.avatarImage,
  }) : super(key: key);
  final VoidCallback func;
  final CommunityModel community;
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
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: FileImage(avatarImage!),
              )
            : CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: NetworkImage(community.communityAvatar),
              ),
      ),
    );
  }
}
