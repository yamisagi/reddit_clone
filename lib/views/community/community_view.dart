// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/util/community_view/community_header.dart';

import '../../util/post/post_card.dart';

class CommunityView extends ConsumerWidget {
  const CommunityView({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(userProvider)?.uid ?? '';
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
            data: (community) {
              return NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.2,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              community.communityBanner,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: Constants.regularPadding,
                      sliver: CommunityHeaderWidget(
                        community: community,
                        isModerator:
                            community.communityModerators.contains(uid),
                        isMember: community.communityMembers.contains(uid),
                      ),
                    ),
                  ];
                }),
                body: ref.watch(getCommunityPostsProvider(name)).when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text(error.toString())),
                      data: (posts) {
                        if (posts.isEmpty) {
                          return Center(
                            child: Text(
                              'No posts yet',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return PostCardWidget(post);
                          },
                        );
                      },
                    ),
              );
            },
          ),
    );
  }
}
