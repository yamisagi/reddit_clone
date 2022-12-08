import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';

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
          decoration: BoxDecoration(
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
                        //
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.communityProfileImg),
                                    radius: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  Padding(
                                    padding: Constants.postCardPadding,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '/r/${post.communityName}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          'u/${post.author}',
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user?.uid)
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                  color: ColorPallete.redColor,
                                ),
                            ],
                          ),
                          const Divider(
                            color: ColorPallete.greyColor,
                            thickness: 3,
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
                                post.link ?? user!.profilePic,
                                fit: BoxFit.contain,
                              ),
                            ),

                          // TODO: Add Type Link and Type Text Here
                          // TODO: And clean up the code that look sick
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
