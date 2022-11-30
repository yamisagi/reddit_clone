import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/community_model.dart';
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

  Stream<List<CommunityModel>> getCommunities(String uid) {
    return _communityCollection
        .where('communityMembers', arrayContains: uid)
        .snapshots()
        .map((event) {
      return event.docs
          .map(
              (e) => CommunityModel.fromMap(e.data() as Map<String, dynamic>) //
              )
          .toList();
    });
  }

  Stream<CommunityModel> getCommunityByName(String communityName) {
    return _communityCollection.doc(communityName).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _communityCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

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
}
