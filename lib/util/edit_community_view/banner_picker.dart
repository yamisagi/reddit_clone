// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class BannerPicker extends StatelessWidget {
  const BannerPicker({
    Key? key,
    required this.func,
    required this.community,
    required this.bannerImage,
  }) : super(key: key);
  final VoidCallback func;
  final CommunityModel community;
  final File? bannerImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: DottedBorder(
        color: ColorPallete.darkModeAppTheme.textTheme.bodyText2!.color!,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: Constants.dottedBorder,
        dashPattern: const [15, 5],
        child: ClipRRect(
          borderRadius: Constants.rectRadius,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: ColorPallete.darkModeAppTheme.backgroundColor,
              borderRadius: Constants.rectRadius,
            ),
            child: bannerImage != null
                ? ClipRRect(
                    child: Image.file(
                      bannerImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : community.communityBanner.isEmpty ||
                        community.communityBanner == Constants.bannerDefault
                    ? Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: ColorPallete.whiteColor,
                        ),
                      )
                    : Image.network(
                        community.communityBanner,
                        fit: BoxFit.cover,
                      ),
          ),
        ),
      ),
    );
  }
}
