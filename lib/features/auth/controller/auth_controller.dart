import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repo/auth_repo.dart';
import 'package:reddit_clone/models/user_model.dart';

// To Fix the error invalid state of Scaffold in the widget tree we need to provide the Key for the Scaffold
final scaffoldMessengerKeyProvider = Provider<UniqueKey>((ref) => UniqueKey());

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
      authRepository: ref.watch(authRepositoryProvider), ref: ref),
);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = true;
    try {
      await _authRepository.signInWithEmailAndPassword(
        context,
        _ref.read(scaffoldMessengerKeyProvider),
        email: email,
        password: password,
      );
      state = false;
    } on FirebaseAuthException {
      state = false;
      _ref.read(userProvider.notifier).update((state) => null);
    }
  }

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = true;
    await _authRepository.signUpWithEmailAndPassword(
      context,
      _ref.read(scaffoldMessengerKeyProvider),
      email: email,
      password: password,
    );
    state = false;
  }

  Future signOut() async {
    await _authRepository.signOut();
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }
}
