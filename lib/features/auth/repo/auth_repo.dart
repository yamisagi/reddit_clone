import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/constants/constants.dart';
import 'package:reddit_clone/constants/firebase_constants.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/providers/firebase_providers.dart';
import 'package:reddit_clone/util/common/snackbar.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(firestoreProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // In case if instances is null then it will create new instance for us.

  AuthRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // This will return the current users changes. Logged in or logged out etc..
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    Key key, {
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ??
              '${userCredential.user!.email?.split('@')[0].toUpperCase()}',
          uid: userCredential.user!.uid,
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAnonymous: userCredential.user!.isAnonymous,
          karma: 0,
          awards: ['thankyou', 'plusone'],
        );
        await _usersCollection
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        showSnackBar(context, 'No user found for that email.', key);
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        showSnackBar(context, 'Wrong password provided for that user.', key);
      } else {
        log(e.code);
        showSnackBar(context, e.code, key);
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    Key key, {
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ??
              '${userCredential.user!.email?.split('@')[0].toUpperCase()}',
          uid: userCredential.user!.uid,
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          isAnonymous: userCredential.user!.isAnonymous,
          karma: 0,
          awards: [],
        );
        await _usersCollection
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        showSnackBar(context, 'The password provided is too weak.', key);
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        showSnackBar(
            context, 'The account already exists for that email.', key);
      } else {
        log(e.code);
        showSnackBar(context, e.code, key);
      }
    } catch (e) {
      log(e.toString());
      showSnackBar(context, 'Something went wrong.', key);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _usersCollection.doc(uid).snapshots().map((snapshot) =>
        UserModel.fromMap(snapshot.data() as Map<String, dynamic>));
  }
}
