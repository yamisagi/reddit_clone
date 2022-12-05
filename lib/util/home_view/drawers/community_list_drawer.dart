import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create_community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text(Constants.createCommunity),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: Center(
                          child: Text(
                            Constants.noCommunities,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge //
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("r/${data[index].communityName}"),
                            leading: CircleAvatar(
                              backgroundColor: ColorPallete.greyColor,
                              backgroundImage:
                                  NetworkImage(data[index].communityAvatar),
                            ),
                            onTap: () {
                              Routemaster.of(context)
                                  .push("/r/${data[index].communityName}");
                            },
                          );
                        },
                      ),
                    );
                  },
                  error: ((error, stackTrace) =>
                      Center(child: Text('Error $error'))),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ],
        ),
      ),
    );
  }
}
