import 'package:flutter/material.dart';
import 'package:reddit_clone/views/community_view.dart';
import 'package:reddit_clone/views/home_view.dart';
import 'package:reddit_clone/views/login_view.dart';
import 'package:routemaster/routemaster.dart';

import 'util/common/loading_widget.dart';

final signedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoginView()),
});

final signedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: HomeView()),
  '/create_community': (_) =>
      const MaterialPage<void>(child: CreateCommunityView()),
});

final loadingRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoadingWidget()),
});
