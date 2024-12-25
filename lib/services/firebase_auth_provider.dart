import 'package:firebase_core/firebase_core.dart';
import 'package:nothing_notes/services/firebase_options.dart';
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
      throw UserNotFoundException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFoundException();
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
        throw UserNotFoundException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          throw OperationNotAllowedException();
        case "weak-password":
          throw WeakPasswordException();
        case "too-many-requests":
          throw TooManyRequestsException();
        case "user-token-expired":
          throw UserTokenExpiredException();
        case "network-request-failed":
          throw NetworkException();
        default:
          throw GenericRegistrationException();
      }
    } catch (e) {
      throw GenericRegistrationException();
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
        throw UserNotFoundException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          throw UserNotFoundException();
        case "user-disabled":
          throw UserDisabledException();
        case "invalid-email":
          throw InvalidCredentialException();
        case "wrong-password":
          throw WrongPasswordException();
        case "too-many-requests":
          throw TooManyRequestsException();
        case "user-token-expired":
          throw UserTokenExpiredException();
        case "network-request-failed":
          throw NetworkException();
        case "invalid-credential":
          throw InvalidCredentialException();
        case "operation-not-allowed":
          throw OperationNotAllowedException();
        default:
          throw GenericLoginException();
      }
    } catch (_) {
      throw GenericLoginException();
    }
  }

  @override
  Future<void> initialise() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
