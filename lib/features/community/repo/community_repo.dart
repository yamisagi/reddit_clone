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

  CollectionReference get _communityCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
