// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repo/community_repo.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/util/common/snackbar.dart';
import 'package:routemaster/routemaster.dart';

final getCommunityProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepo = ref.watch(communityRepoProvider);
  return CommunityController(communityRepository: communityRepo, ref: ref);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  CommunityController(
      {required CommunityRepository communityRepository, required Ref ref})
      : _communityRepository = communityRepository,
        _ref = ref,
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
    final uid = _ref.read(userProvider)?.uid ?? '';
    return _communityRepository.getCommunities(uid);
  }
}
