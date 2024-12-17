import 'package:nothing_notes/services/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;

  Future<void> initialise();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> register({
    required String email,
    required String password,
  });

  Future<void> logOut();

  Future<bool> emailVerification();
}
