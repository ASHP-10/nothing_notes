import 'package:nothing_notes/services/auth_provider.dart';
import 'package:nothing_notes/services/auth_user.dart';
import 'package:nothing_notes/services/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialise() => provider.initialise();

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) =>
      provider.register(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) =>
      provider.signIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<bool> emailVerification() => provider.emailVerification();
}
