import 'package:flutter/material.dart';
import 'package:reddit_clone/views/community_view.dart';
import 'package:reddit_clone/views/create_community_view.dart';
import 'package:reddit_clone/views/edit_community_view.dart';
import 'package:reddit_clone/views/home_view.dart';
import 'package:reddit_clone/views/login_view.dart';
import 'package:reddit_clone/views/modtools_view.dart';
import 'package:routemaster/routemaster.dart';

import 'util/common/loading_widget.dart';

final signedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoginView()),
});

final signedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: HomeView()),
  '/create_community': (_) =>
      const MaterialPage<void>(child: CreateCommunityView()),
  // This is the route for the community view
  // Which is special usage. And it is dynamic.
  '/r/:name': (info) => MaterialPage<void>(
      child: CommunityView(name: info.pathParameters['name']!)),
  //
  //
  '/mod_tools/:name': (info) => MaterialPage<void>(
        child: ModToolsView(
          name: info.pathParameters['name']!,
        ),
      ),
  //
  //
  '/edit_community/:name': (info) => MaterialPage<void>(
        child: EditCommunityView(
          name: info.pathParameters['name']!,
        ),
      ),
});

final loadingRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoadingWidget()),
});
