// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/profile/controller/profile_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/util/post/post_card.dart';
import 'package:reddit_clone/util/profile_view/user_header.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileView extends ConsumerWidget {
  final String uid;
  const UserProfileView({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(userProvider)?.uid ?? '';
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
            data: (user) {
              return NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.27,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              user.banner,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: Constants.regularPadding.copyWith(
                              bottom: MediaQuery.of(context).size.height * 0.1,
                            ),
                            alignment: Alignment.bottomLeft,
                            child: CircleAvatar(
                              radius: kIsWeb
                                  ? MediaQuery.of(context).size.height * 0.03
                                  : MediaQuery.of(context).size.width * 0.12,
                              backgroundImage: NetworkImage(
                                user.profilePic,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              return Container(
                                padding: Constants.regularPadding,
                                alignment: Alignment.bottomLeft,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Routemaster.of(context).push(
                                      '/edit_profile/$uid',
                                    );
                                  },
                                  child: Text(
                                    'Edit Profile',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: ColorPallete.whiteColor,
                                        ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: Constants.regularPadding,
                      sliver: UserProfileHeader(user: user),
                    ),
                  ];
                }),
                body: ref.watch(getUserPostsProvider(uid)).when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text(error.toString())),
                      data: (posts) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
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
