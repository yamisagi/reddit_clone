// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/util/community_view/community_header.dart';

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
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.2,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(community.communityBanner,
                                  fit: BoxFit.cover),
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
                  body: Center(
                    child: Text(community.communityName),
                  ));
            },
          ),
    );
  }
}
