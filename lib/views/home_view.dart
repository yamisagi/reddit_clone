import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/util/home_view/drawers/community_list_drawer.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  void displayCommunityListDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
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
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(user!.profilePic),
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      body: Center(
        child: Text('User ID: ${user.uid}'),
      ),
    );
  }
}
