// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repo/post_repo.dart';
import 'package:reddit_clone/features/profile/controller/profile_controller.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/providers/storage_repo_provider.dart';
import 'package:reddit_clone/util/common/enums.dart';
import 'package:reddit_clone/util/common/snackbar.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
    storageRepository: storageRepo,
  );
});

final fetchPostsProvider =
    StreamProvider.family(((ref, List<CommunityModel> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
}));

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getPostDetailbyId(postId);
});
final getCommentsByIdProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> postText(
      {required BuildContext context,
      required String title,
      required CommunityModel selectedCommunity,
      required String description}) async {
    state = true;

    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      body: description,
      communityName: selectedCommunity.communityName,
      communityProfileImg: selectedCommunity.communityAvatar,
      author: user.name,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      awards: [],
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
    );

    try {
      await _postRepository.addPost(post);
      state = false;
      showSnackBar(
        context,
        'Posted to ${selectedCommunity.communityName}',
        _ref.read(scaffoldMessengerKeyProvider),
      );
      await _ref
          .read(profileControllerProvider.notifier)
          .updateUserKarma(UserKarma.textPost);
      Routemaster.of(context).pop();
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Future<void> postLink({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;

    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;

    final post = Post(
      id: postId,
      title: title,
      link: link,
      communityName: selectedCommunity.communityName,
      communityProfileImg: selectedCommunity.communityAvatar,
      author: user.name,
      upVotes: [],
      downVotes: [],
      commentCount: 0,
      awards: [],
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
    );

    try {
      await _postRepository.addPost(post);
      state = false;
      showSnackBar(
        context,
        'Posted to ${selectedCommunity.communityName}',
        _ref.read(scaffoldMessengerKeyProvider),
      );

      await _ref
          .read(profileControllerProvider.notifier)
          .updateUserKarma(UserKarma.linkPost);
      Routemaster.of(context).pop();
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Future<void> postImage({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File? image,
    required Uint8List? webFile,
  }) async {
    state = true;

    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'post/${selectedCommunity.communityName}',
        id: postId,
        file: image,
        webFile: webFile
        );

    try {
      if (image == null || webFile == null) {
        showSnackBar(
          context,
          'Image is required',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      final post = Post(
        id: postId,
        title: title,
        link: imageRes,
        communityName: selectedCommunity.communityName,
        communityProfileImg: selectedCommunity.communityAvatar,
        author: user.name,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        awards: [],
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
      );
      await _postRepository.addPost(post);
      state = false;
      showSnackBar(
        context,
        'Posted to ${selectedCommunity.communityName}',
        _ref.read(scaffoldMessengerKeyProvider),
      );
      await _ref
          .read(profileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      Routemaster.of(context).pop();
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Stream<List<Post>> fetchUserPosts(List<CommunityModel> communityName) {
    if (communityName.isNotEmpty) {
      return _postRepository.fetchPosts(communityName);
    }
    return const Stream.empty();
  }

  Future<void> deletePost(BuildContext context, Post post) async {
    try {
      await _postRepository.deletePost(post);

      await _ref
          .read(profileControllerProvider.notifier)
          .updateUserKarma(UserKarma.deletePost);
      showSnackBar(
        context,
        'Post deleted',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Future<void> upvotePost(BuildContext context, Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    try {
      await _postRepository.upvotePost(post, uid);
      showSnackBar(
        context,
        'Upvoted',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Future<void> downvotePost(BuildContext context, Post post) async {
    final uid = _ref.read(userProvider)!.uid;
    try {
      await _postRepository.downvotePost(post, uid);
      showSnackBar(
        context,
        'Downvoted',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Stream<Post> getPostDetailbyId(String id) {
    return _postRepository.getPostDetailbyId(id);
  }

  Future<void> addComment(
    BuildContext context, {
    required String comment,
    required Post post,
  }) async {
    try {
      final user = _ref.read(userProvider)!;
      String commentId = const Uuid().v4();
      Comment newComment = Comment(
        username: user.name,
        profilePicUrl: user.profilePic,
        id: commentId,
        text: comment,
        postId: post.id,
        createdAt: DateTime.now(),
      );
      await _postRepository.addComment(newComment);

      await _ref
          .read(profileControllerProvider.notifier)
          .updateUserKarma(UserKarma.comment);

      showSnackBar(
        context,
        'Comment added',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Stream<List<Comment>> getComments(String postId) {
    return _postRepository.getComments(postId);
  }

  Future<void> awardPost(BuildContext context,
      {required Post post, required String award}) async {
    try {
      final user = _ref.read(userProvider)!;
      await _postRepository.awardPost(
        awardName: award,
        post: post,
        userId: user.uid,
      );
      // Should control if the post sender is the same as the award sender
      if (post.uid == user.uid) {
        showSnackBar(
          context,
          'You can\'t award your own post',
          _ref.read(scaffoldMessengerKeyProvider),
        );
        Routemaster.of(context).pop();
      } else {
        await _ref
            .read(profileControllerProvider.notifier)
            .updateUserKarma(UserKarma.awardPost);

        _ref.read(userProvider.notifier).update((state) {
          state?.awards.remove(award);
          return state;
        });

        showSnackBar(
          context,
          'Awarded',
          _ref.read(scaffoldMessengerKeyProvider),
        );
        Routemaster.of(context).pop();
      }
    } on Exception catch (e) {
      log(e.toString());
      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }
}
