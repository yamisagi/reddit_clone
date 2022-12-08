import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/providers/firebase_providers.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _postsCollection =>
      _firestore.collection(FirebaseConstants.postsCollection);

  Future<void> addPost(Post post) async {
    try {
      await _postsCollection.doc(post.id).set(post.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<List<Post>> fetchPosts(List<CommunityModel> communities) {
    try {
      return _postsCollection
          .where('communityName',
              whereIn: communities.map((e) => e.communityName).toList())
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }
}
