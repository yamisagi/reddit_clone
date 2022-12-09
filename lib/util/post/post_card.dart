import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/post/post_card_bottom.dart';
import 'package:reddit_clone/util/post/post_header.dart';

class PostCardWidget extends ConsumerWidget {
  const PostCardWidget(this.post, {super.key});
  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider.notifier);
    return Column(
      children: [
        Container(
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
          padding: Constants.regularPadding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: Constants.postCardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PostHeaderWidget(post: post, user: user!),
                          const Divider(
                            color: ColorPallete.greyColor,
                            thickness: 1,
                          ),
                          Padding(
                            padding: Constants.regularPadding,
                            child: Text(
                              post.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                post.link ?? user.profilePic,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          if (isTypeLink)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionVertical,
                                  link: post.link!,
                                ),
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: Constants.regularPadding,
                                child: Text(post.body!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                            ),
                          PostCardBottomWidget(post: post, user: user),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
