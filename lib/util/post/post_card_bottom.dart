// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:routemaster/routemaster.dart';

class PostCardBottomWidget extends ConsumerWidget {
  const PostCardBottomWidget({
    super.key,
    required this.post,
    required this.user,
  });
  final Post post;
  final UserModel user;
  Future<void> deletePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  Future<void> upvotePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).upvotePost(context, post);
  }

  Future<void> downvotePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).downvotePost(context, post);
  }

  void navigateToComments(BuildContext context) {
    Routemaster.of(context).push('/comments/${post.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              iconSize: MediaQuery.of(context).size.width * 0.05,
              onPressed: () async {
                await upvotePost(context, ref);
              },
              icon: const Icon(Constants.up),
              color: post.upVotes.contains(user.uid)
                  ? ColorPallete.redColor
                  : null,
            ),
            Text(
                '${post.upVotes.length - post.downVotes.length == 0 ? 'Vote' : post.upVotes.length - post.downVotes.length}',
                style: Theme.of(context).textTheme.bodyMedium),
            IconButton(
              iconSize: MediaQuery.of(context).size.width * 0.05,
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
        GestureDetector(
          onTap: () {
            navigateToComments(context);
          },
          child: Row(
            children: [
              Icon(
                  size: MediaQuery.of(context).size.width * 0.05,
                  Icons.comment),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Text('${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        // If current user is admin of the community then show the admin panel
        ref.watch(getCommunityByNameProvider(post.communityName)).when(
              error: (error, stackTrace) => Container(),
              loading: () => Container(),
              data: (data) {
                if (data.communityModerators.contains(user.uid)) {
                  return IconButton(
                    onPressed: () async {
                      // For now we will just delete the post
                      await deletePost(context, ref);
                    },
                    icon: const Icon(Icons.admin_panel_settings),
                  );
                } else {
                  return Container();
                }
              },
            )
      ],
    );
  }
}
