import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repo/auth_repo.dart';

final authControllProvider = Provider<AuthController>(
    (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)));

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _authRepository.signUpWithEmailAndPassword(email, password);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
