// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/repo/post_repo.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/providers/storage_repo_provider.dart';
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
      author: user.profilePic,
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
      Routemaster.of(context)
          .push('/r/${selectedCommunity.communityName}');
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
      author: user.profilePic,
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
      Routemaster.of(context)
          .push('/r/${selectedCommunity.communityName}');
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
  }) async {
    state = true;

    String postId = const Uuid().v4();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'post/${selectedCommunity.communityName}',
        id: postId,
        file: image);

    try {
      if (image == null) {
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
        author: user.profilePic,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        awards: [],
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
      );
      await _postRepository.addPost(post);
      state = false;
      showSnackBar(
        context,
        'Posted to ${selectedCommunity.communityName}',
        _ref.read(scaffoldMessengerKeyProvider),
      );
      Routemaster.of(context)
          .push('/r/${selectedCommunity.communityName}');
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
