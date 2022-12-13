// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';
import 'package:routemaster/routemaster.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({
    Key? key,
    required this.post,
    required this.user,
  }) : super(key: key);
  final Post post;
  final UserModel user;
  Future<void> deletePost(BuildContext context, WidgetRef ref) async {
    await ref.read(postControllerProvider.notifier).deletePost(context, post);
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/${post.author}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => navigateToCommunity(context),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(post.communityProfileImg),
                  radius: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.03
                      : MediaQuery.of(context).size.width * 0.05,
                ),
              ),
              Padding(
                padding: Constants.postCardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '/r/${post.communityName}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    GestureDetector(
                      onTap: () => navigateToUserProfile(context),
                      child: Text(
                        'u/${post.author}',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (post.uid == user.uid)
            Consumer(
              builder: (context, ref, child) => IconButton(
                onPressed: () async {
                  await deletePost(context, ref);
                },
                icon: Icon(
                  Icons.delete,
                  size: kIsWeb
                      ? MediaQuery.of(context).size.height * 0.03
                      : MediaQuery.of(context).size.width * 0.05,
                ),
                color: ColorPallete.redColor,
              ),
            ),
        ],
      ),
    );
  }
}
