// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';

import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';

class CommentCardWidget extends ConsumerWidget {
  const CommentCardWidget({
    super.key,
    required this.comment,
  });
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider.notifier);
    return Container(
      margin: Constants.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: currentTheme.themeMode == ThemeMode.dark
              ? ColorPallete.darkModeAppTheme.cardColor
              : ColorPallete.lightGreyColor,
        ),
        borderRadius: Constants.rectRadius,
        shape: BoxShape.rectangle,
        color: currentTheme.themeMode == ThemeMode.dark
            ? ColorPallete.darkModeAppTheme.backgroundColor
            : ColorPallete.lightGreyColor,
      ),
      padding: Constants.smallPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: currentTheme.themeMode == ThemeMode.dark
                      ? ColorPallete.darkModeAppTheme.backgroundColor
                      : ColorPallete.whiteColor,
                  backgroundImage: NetworkImage(comment.profilePicUrl),
                 radius: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.03
                      : MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'u/${comment.username}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      comment.text,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            ],
          ),
          const Divider(
            color: ColorPallete.greyColor,
            thickness: 1,
          ),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.reply)),
              Text('Reply', style: Theme.of(context).textTheme.bodySmall)
            ],
          ),
        ],
      ),
    );
  }
}
