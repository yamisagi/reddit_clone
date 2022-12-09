import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/comment_model.dart';
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
  CollectionReference get _commentsCollection =>
      _firestore.collection(FirebaseConstants.commentsCollection);

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

  Future<void> deletePost(Post post) async {
    try {
      await _postsCollection.doc(post.id).delete();
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Future<void> upvotePost(Post post, String userId) async {
    try {
      if (post.downVotes.contains(userId)) {
        await _postsCollection.doc(post.id).update({
          'downVotes': FieldValue.arrayRemove([userId])
        });
      }
      if (post.upVotes.contains(userId)) {
        await _postsCollection.doc(post.id).update({
          'upVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        await _postsCollection.doc(post.id).update({
          'upVotes': FieldValue.arrayUnion([userId])
        });
      }
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Future<void> downvotePost(Post post, String userId) async {
    try {
      if (post.upVotes.contains(userId)) {
        await _postsCollection.doc(post.id).update({
          'upVotes': FieldValue.arrayRemove([userId])
        });
      }
      if (post.downVotes.contains(userId)) {
        await _postsCollection.doc(post.id).update({
          'downVotes': FieldValue.arrayRemove([userId])
        });
      } else {
        await _postsCollection.doc(post.id).update({
          'downVotes': FieldValue.arrayUnion([userId])
        });
      }
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<Post> getPostDetailbyId(String id) {
    try {
      return _postsCollection.doc(id).snapshots().map((snapshot) {
        return Post.fromMap(snapshot.data() as Map<String, dynamic>);
      });
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Future<void> addComment(Comment comment) async {
    try {
      await _commentsCollection.doc(comment.id).set(comment.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }
}
