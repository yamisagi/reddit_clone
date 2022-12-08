import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';

class PostCardWidget extends ConsumerWidget {
  const PostCardWidget(this.post, {super.key});
  final Post post;

  Future<void> deletePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  Future<void> upvotePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).upvotePost(context, post);
  }

  Future<void> downvotePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).downvotePost(context, post);
  }

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
                                  onPressed: () async {
                                    await deletePost(context, ref);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: ColorPallete.redColor,
                                ),
                            ],
                          ),
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
                                post.link ?? user!.profilePic,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    onPressed: () async {
                                      await upvotePost(context, ref);
                                    },
                                    icon: const Icon(Constants.up),
                                    color: post.upVotes.contains(user!.uid)
                                        ? ColorPallete.redColor
                                        : null,
                                  ),
                                  Text(
                                      '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    onPressed: () async {
                                      await downvotePost(context, ref);
                                    },
                                    icon: const Icon(Constants.down),
                                    color: post.downVotes.contains(user.uid)
                                        ? ColorPallete.blueColor
                                        : null,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    onPressed: () {},
                                    icon: const Icon(Icons.comment),
                                  ),
                                  Text(
                                      '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              ),
                            ],
                          )
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
