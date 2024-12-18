import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified}); // main constructor
  factory AuthUser.fromFirebase(User user) => AuthUser(
      isEmailVerified: user
          .emailVerified); // factory constructor for creating an AuthUser from Firebase User
}
