import 'package:flutter/material.dart';
import 'package:nothing_notes/services/auth_service.dart';
import 'package:nothing_notes/views/login_view.dart';
import 'package:nothing_notes/views/notes_view.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialise(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase()
                .currentUser; // Add Specific Route, changed for debugging purposes
            if (user != null) {
              if (user.isEmailVerified) {
                return const LoginView();
              } else {
                return const LoginView();
              }
            } else {
              return const LoginView();
            }
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
