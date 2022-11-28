import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/views/home_view.dart';
import 'package:reddit_clone/features/auth/views/login_view.dart';
import 'package:routemaster/routemaster.dart';

final signedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoginView()),
});

final signedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: HomeView()),
});
