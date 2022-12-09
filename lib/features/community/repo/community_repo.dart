import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/providers/firebase_providers.dart';

final communityRepoProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepository(firestore: ref.read(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Future createCommunity(CommunityModel community) async {
    try {
      final communityDoc =
          await _communityCollection.doc(community.communityName).get();
      if (communityDoc.exists) {
        throw Exception('Community already exists');
      }
      await _communityCollection
          .doc(community.communityName)
          .set(community.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communityCollection
        .where('communityMembers', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities
            .add(CommunityModel.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<CommunityModel> getCommunityByName(String communityName) {
    return _communityCollection.doc(communityName).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _communityCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
  CollectionReference get _postCollection =>
      FirebaseFirestore.instance.collection(FirebaseConstants.postsCollection);

  Future editCommunity(CommunityModel community) async {
    try {
      final communityDoc =
          await _communityCollection.doc(community.communityName).get();
      if (!communityDoc.exists) {
        throw Exception('Community does not exists');
      }
      await _communityCollection
          .doc(community.communityName)
          .update(community.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Future<void> joinCommunity(String communityName, String uid) async {
    try {
      final communityDoc = await _communityCollection.doc(communityName).get();
      if (!communityDoc.exists) {
        throw Exception('Community does not exists');
      }
      final community =
          CommunityModel.fromMap(communityDoc.data() as Map<String, dynamic>);

      if (community.communityMembers.contains(uid)) {
        throw Exception('Already a member of the community');
      }

      final updatedCommunity = community.copyWith(
        communityMembers: [...community.communityMembers, uid],
      );

      await _communityCollection
          .doc(communityName)
          .update(updatedCommunity.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Future<void> leaveCommunity(String communityName, String uid) async {
    try {
      final communityDoc = await _communityCollection.doc(communityName).get();
      if (!communityDoc.exists) {
        throw Exception('Community does not exists');
      }
      final community =
          CommunityModel.fromMap(communityDoc.data() as Map<String, dynamic>);

      if (!community.communityMembers.contains(uid)) {
        throw Exception('Not a member of the community');
      }

      final updatedCommunity = community.copyWith(
        communityMembers: community.communityMembers
            .where((element) => element != uid)
            .toList(),
      );

      await _communityCollection
          .doc(communityName)
          .update(updatedCommunity.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<List<CommunityModel>> searchCommunities(String query) {
    return _communityCollection
        .where(
          'communityName',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty ? 0 : '${query}z',
        )
        .snapshots()
        .map((event) {
      return event.docs
          .map(
              (e) => CommunityModel.fromMap(e.data() as Map<String, dynamic>) //
              )
          .toList();
    });
  }

  Future<void> addModerator(String communityName, List<String> uid) async {
    try {
      await _communityCollection
          .doc(communityName)
          .update({'communityModerators': uid});
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    try {
      return _postCollection
          .where('communityName', isEqualTo: communityName)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }
}
