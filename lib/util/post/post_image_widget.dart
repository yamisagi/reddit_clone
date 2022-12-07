import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    Key? key,
    required this.currentTheme,
    required this.bannerImage,
    required this.onTap,
  }) : super(key: key);

  final ThemeMode currentTheme;
  final File? bannerImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.regularPadding,
      child: GestureDetector(
        onTap: onTap,
        child: DottedBorder(
          color: currentTheme == ThemeMode.light
              ? ColorPallete.darkModeAppTheme.backgroundColor
              : ColorPallete.lightModeAppTheme.backgroundColor,
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
                  color: currentTheme == ThemeMode.light
                      ? ColorPallete.lightGreyColor
                      : ColorPallete.darkModeAppTheme.backgroundColor,
                  borderRadius: Constants.rectRadius,
                ),
                child: bannerImage != null
                    ? ClipRRect(
                        child: Image.file(
                          bannerImage ?? File(''),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: MediaQuery.of(context).size.width * 0.1,
                          color: ColorPallete.whiteColor,
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
