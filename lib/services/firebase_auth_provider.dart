import 'package:firebase_core/firebase_core.dart';
import 'package:nothing_notes/firebase_options.dart';
import 'package:nothing_notes/services/auth_user.dart';
import 'package:nothing_notes/services/auth_provider.dart';
import 'package:nothing_notes/constants/Exceptions/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<bool> emailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.sendEmailVerification();
      return true;
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFoundAuthException();
    }
  }

  @override
  Future<AuthUser> register({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw EmailAlreadyInUseAuthException();
        case "invalid-email":
          throw InvalidEmailAuthException();
        case "operation-not-allowed":
          throw OperationNotAllowedAuthException();
        case "weak-password":
          throw WeakPasswordAuthException();
        case "too-many-requests":
          throw TooManyRequestsAuthException();
        case "user-token-expired":
          throw UserTokenExpiredAuthException();
        case "network-request-failed":
          throw NetworkAuthException();
        default:
          throw GenericRegistrationAuthException();
      }
    } catch (_) {
      throw GenericRegistrationAuthException();
    }
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          throw UserNotFoundAuthException();
        case "user-disabled":
          throw UserDisabledAuthException();
        case "invalid-email":
          throw InvalidCredentialAuthException();
        case "wrong-password":
          throw WrongPasswordAuthException();
        case "too-many-requests":
          throw TooManyRequestsAuthException();
        case "user-token-expired":
          throw UserTokenExpiredAuthException();
        case "network-request-failed":
          throw NetworkAuthException();
        case "invalid-credential":
          throw InvalidCredentialAuthException();
        case "operation-not-allowed":
          throw OperationNotAllowedAuthException();
        default:
          throw GenericLoginAuthException();
      }
    } catch (_) {
      throw GenericLoginAuthException();
    }
  }

  @override
  Future<void> initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
