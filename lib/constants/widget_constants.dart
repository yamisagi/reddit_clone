import 'package:flutter/material.dart';
import 'package:reddit_clone/views/add_post/add_post_view.dart';
import 'package:reddit_clone/views/feed_view.dart';

class WidgetConstant {
  static const tabViews = <Widget>[
    FeedView(),
    AddPostView(),
  ];
}
