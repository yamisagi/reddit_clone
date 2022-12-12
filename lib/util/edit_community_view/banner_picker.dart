// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';

class BannerPicker extends StatelessWidget {
  const BannerPicker({
    Key? key,
    required this.bannerWebFile,
    required this.func,
    required this.community,
    required this.bannerImage,
  }) : super(key: key);
  final VoidCallback func;
  final CommunityModel community;
  final File? bannerImage;
  final Uint8List? bannerWebFile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: ResponsiveWidget(
        child: DottedBorder(
          color: ColorPallete.darkModeAppTheme.textTheme.bodyText2!.color!,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: Constants.dottedBorder,
          dashPattern: const [15, 5],
          child: ClipRRect(
            borderRadius: Constants.rectRadius,
            child: Consumer(
              builder: (context, ref, child) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: ref.read(themeNotifierProvider.notifier).themeMode ==
                            ThemeMode.dark
                        ? ColorPallete.darkModeAppTheme.backgroundColor
                        : ColorPallete.lightGreyColor,
                    borderRadius: Constants.rectRadius,
                  ),
                  child: bannerWebFile != null
                      ? ClipRRect(
                          child: Image.memory(
                            bannerWebFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : bannerImage != null
                          ? ClipRRect(
                              child: Image.file(
                                bannerImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : community.communityBanner.isEmpty ||
                                  community.communityBanner ==
                                      Constants.bannerDefault
                              ? Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size:
                                        MediaQuery.of(context).size.width * 0.1,
                                    color: ColorPallete.whiteColor,
                                  ),
                                )
                              : Image.network(
                                  community.communityBanner,
                                  fit: BoxFit.cover,
                                ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
