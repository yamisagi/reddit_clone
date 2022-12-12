import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';

class UserBannerPicker extends StatelessWidget {
  const UserBannerPicker({
    Key? key,
    required this.bannerImage,
    required this.user,
    required this.bannerWebFile,
    required this.func,
  }) : super(key: key);

  final File? bannerImage;
  final UserModel user;
  final VoidCallback func;
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
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: ColorPallete.darkModeAppTheme.backgroundColor,
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
                      : user.banner.isEmpty ||
                              user.banner == Constants.bannerDefault
                          ? Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: MediaQuery.of(context).size.width * 0.1,
                                color: ColorPallete.whiteColor,
                              ),
                            )
                          : Image.network(
                              user.banner,
                              fit: BoxFit.cover,
                            ),
            ),
          ),
        ),
      ),
    );
  }
}
