// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repo/community_repo.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/providers/storage_repo_provider.dart';
import 'package:reddit_clone/util/common/snackbar.dart';
import 'package:routemaster/routemaster.dart';

// Create StreamProvider to get communities
final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunities();
});

final getCommunityPostsProvider =
    StreamProvider.family((ref, String communityName) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityPosts(communityName);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepo = ref.watch(communityRepoProvider);
  final storageRepo = ref.watch(storageRepoProvider);
  return CommunityController(
    communityRepository: communityRepo,
    ref: ref,
    storageRepository: storageRepo,
  );
});
//
//
final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(communityControllerProvider.notifier)
      .searchCommunities(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController(
      {required CommunityRepository communityRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future<void> createCommunity(String name, BuildContext context) async {
    state = true;
    try {
      if (name.isNotEmpty) {
        final uid = _ref.read(userProvider)?.uid ?? '';
        CommunityModel community = CommunityModel(
          communityName: name,
          communityId: name,
          communityAvatar: Constants.avatarDefault,
          communityBanner: Constants.bannerDefault,
          communityMembers: [uid],
          communityModerators: [uid],
        );
        final res = await _communityRepository.createCommunity(community);
        state = false;
        if (res == null) {
          showSnackBar(context, 'Community Created Successfully',
              _ref.read(scaffoldMessengerKeyProvider));
          Routemaster.of(context).pop();
        }

        if (res != null) {
          showSnackBar(context, 'Something went wrong',
              _ref.read(scaffoldMessengerKeyProvider));
          state = false;
        }
      } else {
        showSnackBar(context, 'Community Name Cannot be Empty',
            _ref.read(scaffoldMessengerKeyProvider));
        state = false;
      }
    } on Exception catch (e) {
      if (e.toString().contains('already exists')) {
        showSnackBar(context, 'Community Name Already Exists',
            _ref.read(scaffoldMessengerKeyProvider));
        state = false;
      }
    }
  }

  Stream<CommunityModel> getCommunityByName(String communityName) {
    return _communityRepository.getCommunityByName(communityName);
  }

  Stream<List<CommunityModel>> getCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Future editCommunity(
      {required File? avatarImage,
      required File? bannerImage,
      required Uint8List? avaterWebFile,
      required Uint8List? bannerWebFile,
      required CommunityModel community,
      required BuildContext context}) async {
    state = true;
    try {
      /// Update Community Avatar and Banner with Firebase Storage

      if (avatarImage != null  || bannerImage != null) {
        final avatarUrl = await _storageRepository.storeFile(
            path: 'communities/avatar',
            id: community.communityName,
            file: avatarImage,
            webFile: avaterWebFile);
        community = community.copyWith(communityAvatar: avatarUrl);

        /// Update Community Avatar with Firebase Firestore

        await _communityRepository.editCommunity(community);
        showSnackBar(
          context,
          'Avatar Updated',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      if (bannerImage != null || avatarImage != null) {
        final bannerUrl = await _storageRepository.storeFile(
            path: 'communities/banner',
            id: community.communityName,
            file: bannerImage,
            webFile: bannerWebFile);
        community = community.copyWith(communityBanner: bannerUrl);

        /// Update Community Banner with Firebase Firestore

        await _communityRepository.editCommunity(community);

        showSnackBar(
          context,
          'Banner Updated',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      state = false;
    } on Exception catch (e) {
      log(e.toString());
      state = false;

      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Future<void> joinCommunityOrLeave(
      {required CommunityModel community,
      required BuildContext context}) async {
    try {
      final uid = _ref.read(userProvider)?.uid ?? '';
      if (community.communityMembers.contains(uid)) {
        await _communityRepository.leaveCommunity(community.communityName, uid);
        showSnackBar(
          context,
          'Left Community',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      } else {
        await _communityRepository.joinCommunity(community.communityName, uid);
        showSnackBar(
          context,
          'Joined Community',
          _ref.read(scaffoldMessengerKeyProvider),
        );
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

  Stream<List<CommunityModel>> searchCommunities(String query) {
    // For cost optimization, only search after 3 characters
    if (query.length >= 3) {
      return _communityRepository.searchCommunities(query);
    } else {
      return const Stream.empty();
    }
  }

  Future<void> addModerator(
      {required String communityName,
      required List<String> uid,
      required BuildContext context}) async {
    try {
      await _communityRepository.addModerator(communityName, uid);
      showSnackBar(
        context,
        'Moderator Added',
        _ref.read(scaffoldMessengerKeyProvider),
      );

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

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _communityRepository.getCommunityPosts(communityName);
  }
}
