// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
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
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.27,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: Constants.regularPadding.copyWith(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.12,
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
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                    ),
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
                  body: Center(
                    child: Text(user.name),
                  ));
            },
          ),
    );
  }
}
