import 'package:flutter/material.dart';
import 'package:reddit_clone/views/add_post/add_post_type_view.dart';
import 'package:reddit_clone/views/add_post/add_post_view.dart';
import 'package:reddit_clone/views/comment/comment_view.dart';
import 'package:reddit_clone/views/community/add_mods_view.dart';
import 'package:reddit_clone/views/community/community_view.dart';
import 'package:reddit_clone/views/community/create_community_view.dart';
import 'package:reddit_clone/views/community/edit_community_view.dart';
import 'package:reddit_clone/views/community/home_view.dart';
import 'package:reddit_clone/views/core/login_view.dart';
import 'package:reddit_clone/views/community/modtools_view.dart';
import 'package:reddit_clone/views/user/profile_edit_view.dart';
import 'package:reddit_clone/views/user/user_profile_view.dart';
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

  '/add_mods/:name': (info) => MaterialPage<void>(
        child: AddModsView(
          communityName: info.pathParameters['name']!,
        ),
      ),
  '/u/:uid': (info) => MaterialPage<void>(
        child: UserProfileView(
          uid: info.pathParameters['uid']!,
        ),
      ),
  '/edit_profile/:uid': (info) => MaterialPage<void>(
        child: EditProfileView(
          uid: info.pathParameters['uid']!,
        ),
      ),
  '/add_post/:type': (info) => MaterialPage<void>(
        child: AddPostTypeView(
          type: info.pathParameters['type']!,
        ),
      ),
  '/add_post/': (info) => const MaterialPage<void>(
        child: AddPostView(),
      ),
  '/comments/:postId': (info) => MaterialPage<void>(
        child: CommentView(
          postId: info.pathParameters['postId']!,
        ),
      ),
});

final loadingRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage<void>(child: LoadingWidget()),
});
