import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/util/common/loading_widget.dart';
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
            ref.read(getCommunityProvider).when(
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(data[index].communityName),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data[index].communityBanner),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: ((error, stackTrace) =>
                      Center(child: Text('Error $error'))),
                  loading: () => const LoadingWidget(),
                ),
          ],
        ),
      ),
    );
  }
}
