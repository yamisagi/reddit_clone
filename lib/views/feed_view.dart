import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/util/post/post_card.dart';

class FeedView extends ConsumerWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
          error: ((error, stackTrace) => Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (data) => ref
              .watch(
                fetchPostsProvider(data),
              )
              .when(
                  error: ((error, stackTrace) => Text(error.toString())),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data[index];
                        return PostCardWidget(post);
                      },
                    );
                  }),
        );
  }
}
