import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/util/add_post_view/add_post_item.dart';
import 'package:routemaster/routemaster.dart';

class AddPostView extends ConsumerWidget {
  const AddPostView({super.key});

  void navigateToPostTypeView(BuildContext context, String type) {
    Routemaster.of(context).push('/add_post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHW = kIsWeb? MediaQuery.of(context).size.height * 0.17 : MediaQuery.of(context).size.width * 0.33;
    double iconSize = cardHW * 0.5;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Wrap(
        children: [
          AddPostItem(
            cardHW: cardHW,
            iconSize: iconSize,
            onTap: () => navigateToPostTypeView(context, 'image'),
            icon: Icons.image_outlined,
          ),
          AddPostItem(
            cardHW: cardHW,
            iconSize: iconSize,
            onTap: () => navigateToPostTypeView(context, 'text'),
            icon: Icons.font_download_outlined,
          ),
          AddPostItem(
            cardHW: cardHW,
            iconSize: iconSize,
            onTap: () => navigateToPostTypeView(context, 'link'),
            icon: Icons.link_outlined,
          ),
        ],
      ),
    );
  }
}
