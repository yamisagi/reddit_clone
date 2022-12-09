import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/providers/firebase_providers.dart';

final userProfileRepository = Provider<ProfileRepository>((ref) {
  return ProfileRepository(firestore: ref.read(firestoreProvider));
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _userCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _postCollection =>
      FirebaseFirestore.instance.collection(FirebaseConstants.postsCollection);
  Future editUserProfile(UserModel user) async {
    try {
      final userDoc = await _userCollection.doc(user.uid).get();
      if (!userDoc.exists) {
        throw Exception('User does not exists');
      }
      await _userCollection.doc(user.uid).update(user.toMap());
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }

  Stream<List<Post>> getUserPosts(String uid) {
    try {
      return _postCollection
          .where('uid', isEqualTo: uid)
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

  Future<void> updateUserKarma(UserModel userModel) async {
    try {
      await _userCollection.doc(userModel.uid).update({
        'karma': userModel.karma,
      });
    } on FirebaseException catch (e) {
      log(e.code);
      throw e.message.toString();
    }
  }
}
