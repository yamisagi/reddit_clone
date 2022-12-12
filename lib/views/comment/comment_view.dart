// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/util/post/comment_card.dart';
import 'package:reddit_clone/util/post/post_card.dart';
import 'package:reddit_clone/util/reponsive/responsive.dart';

class CommentView extends ConsumerStatefulWidget {
  const CommentView({
    super.key,
    required this.postId,
  });
  final String postId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView> {
  final commentController = TextEditingController();

  Future<void> addComment(BuildContext context, Post post) async {
    await ref
        .read(postControllerProvider.notifier) //
        .addComment(
          context,
          comment: commentController.text.trim(),
          post: post,
        );
    commentController.clear();
  }

  @override
  dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            error: (error, stack) => Text(error.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
            data: (post) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ResponsiveWidget(
                  child: Column(
                    children: [
                      PostCardWidget(post),
                      Padding(
                        padding: Constants.smallPadding,
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send,
                              ),
                              onPressed: () async {
                                await addComment(context, post);
                                // Then dismiss the keyboard
                                FocusScope.of(context).unfocus(
                                  disposition: UnfocusDisposition.scope,
                                );
                              },
                            ),
                            hintText: 'What are your thoughts?',
                            border: OutlineInputBorder(
                              borderRadius: Constants.rectRadius,
                            ),
                            filled: true,
                          ),
                        ),
                      ),
                      Container(
                        child: ref.watch(getCommentsByIdProvider(post.id)).when(
                              error: (error, stack) => Text(error.toString()),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              data: (comments) {
                                return SingleChildScrollView(
                                  child: ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      final comment = comments[index];
                                      return CommentCardWidget(
                                        comment: comment,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
