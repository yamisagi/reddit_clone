// ignore_for_file: use_build_context_synchronously

import 'dart:developer' show log;
import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/profile/repo/profile_repo.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/providers/storage_repo_provider.dart';
import 'package:reddit_clone/util/common/enums.dart';
import 'package:reddit_clone/util/common/snackbar.dart';
import 'package:routemaster/routemaster.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  final profileRepository = ref.watch(userProfileRepository);
  final storageRepo = ref.watch(storageRepoProvider);
  return ProfileController(
    profileRepository: profileRepository,
    ref: ref,
    storageRepository: storageRepo,
  );
});

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(profileControllerProvider.notifier).getUserPosts(uid);
});

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ProfileController(
      {required ProfileRepository profileRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _profileRepository = profileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  Future editProfile(
      {required File? avatarImage,
      required File? bannerImage,
      required String name,
      required Uint8List? avatarWebFile,
      required Uint8List? bannerWebFile,
      required BuildContext context}) async {
    state = true;
    try {
      UserModel user = _ref.read(userProvider)!;
      if (avatarImage != null || avatarWebFile != null) {
        final avatarUrl = await _storageRepository.storeFile(
          path: 'user/avatar',
          id: user.uid,
          file: avatarImage,
          webFile: avatarWebFile,
        );
        user = user.copyWith(profilePic: avatarUrl);

        await _profileRepository.editUserProfile(user);
        Routemaster.of(context).replace('/u/${user.uid}');
        showSnackBar(
          context,
          'Avatar Updated',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      if (bannerImage != null || bannerWebFile != null) {
        final bannerUrl = await _storageRepository.storeFile(
          path: 'user/banner',
          id: user.uid,
          file: bannerImage,
          webFile: bannerWebFile,
        );
        user = user.copyWith(banner: bannerUrl);
        await _profileRepository.editUserProfile(user);
        Routemaster.of(context).replace('/u/${user.uid}');
        showSnackBar(
          context,
          'Banner Updated',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      if (name.isNotEmpty && name != user.name) {
        user = user.copyWith(name: name);
        _ref.read(userProvider.notifier).update((state) => user);
        await _profileRepository.editUserProfile(user);
        Routemaster.of(context).replace('/u/${user.uid}');
        showSnackBar(
          context,
          'Name Updated',
          _ref.read(scaffoldMessengerKeyProvider),
        );
      }

      state = false;
    } on Exception catch (e) {
      log(e.toString());
      log('This is the error');
      state = false;

      showSnackBar(
        context,
        'Something went wrong',
        _ref.read(scaffoldMessengerKeyProvider),
      );
    }
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _profileRepository.getUserPosts(uid);
  }

  Future<void> updateUserKarma(UserKarma userKarma) async {
    try {
      final user = _ref.read(userProvider)!;
      final updatedUser = user.copyWith(karma: user.karma + userKarma.karma);
      await _profileRepository.updateUserKarma(updatedUser);
      _ref.read(userProvider.notifier).update((state) => updatedUser);
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
