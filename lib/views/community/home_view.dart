import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/widget_constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/product_theme.dart';
import 'package:reddit_clone/theme/theme_notifier.dart';
import 'package:reddit_clone/util/home_view/delegates/search_delegate.dart';
import 'package:reddit_clone/util/home_view/drawers/community_list_drawer.dart';
import 'package:reddit_clone/util/home_view/drawers/user_drawer.dart';
import 'package:routemaster/routemaster.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;

  void displayCommunityListDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayUserDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if (kIsWeb)
            IconButton(
                onPressed: () {
                  Routemaster.of(context).push('/add_post');
                },
                icon: const Icon(Icons.add)),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                displayUserDrawer(context);
              },
              icon: CircleAvatar(
                radius: kIsWeb
                    ? MediaQuery.of(context).size.height * 0.03
                    : MediaQuery.of(context).size.width * 0.05,
                backgroundColor:
                    ref.watch(themeNotifierProvider.notifier).themeMode ==
                            ThemeMode.dark
                        ? ColorPallete.greyColor
                        : ColorPallete.lightGreyColor,
                backgroundImage: NetworkImage(user?.profilePic ?? ''),
              ),
            );
          }),
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer: const UserDrawer(),
      bottomNavigationBar: !kIsWeb
          ? BottomNavigationBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: changePage,
              currentIndex: _page,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: '',
                ),
              ],
            )
          : null,
      body: WidgetConstant.tabViews[_page],
    );
  }
}
