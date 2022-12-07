import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';

class PostTextWidget extends StatelessWidget {
  const PostTextWidget({
    Key? key,
    required this.currentTheme,
    required TextEditingController bodyController,
  })  : _bodyController = bodyController,
        super(key: key);

  final ThemeNotifier currentTheme;
  final TextEditingController _bodyController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.regularPadding,
      child: DottedBorder(
        color: currentTheme.themeMode == ThemeMode.dark
            ? ColorPallete.lightModeAppTheme.backgroundColor
            : ColorPallete.darkModeAppTheme.backgroundColor,
        strokeWidth: 3,
        dashPattern: const [5, 5],
        child: Container(
          decoration: BoxDecoration(
            color: currentTheme.themeMode == ThemeMode.dark
                ? ColorPallete.darkModeAppTheme.backgroundColor
                : ColorPallete.lightGreyColor,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              hintText: 'Enter Text',
              border: InputBorder.none,
              contentPadding: Constants.regularPadding,
            ),
            maxLines: null,
          ),
        ),
      ),
    );
  }
}
