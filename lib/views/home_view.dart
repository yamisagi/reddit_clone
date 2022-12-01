import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/util/home_view/delegates/search_delegate.dart';
import 'package:reddit_clone/util/home_view/drawers/community_list_drawer.dart';
import 'package:reddit_clone/util/home_view/drawers/user_drawer.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  void displayCommunityListDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayUserDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                displayCommunityListDrawer(context);
              },
              icon: const Icon(Icons.menu));
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SearchCommunityDelegate(ref: ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                displayUserDrawer(context);
              },
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user?.profilePic ?? ''),
              ),
            );
          }),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const UserDrawer(),
      body: Center(
        child: Text('User ID: ${user?.uid ?? ''}'),
      ),
    );
  }
}
