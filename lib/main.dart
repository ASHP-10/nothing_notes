import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/views/homepage_view.dart';
import 'package:nothing_notes/views/login_view.dart';
import 'package:nothing_notes/views/notes_view.dart';
import 'package:nothing_notes/views/register_view.dart';
import 'package:nothing_notes/views/verifyemail_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    title: "Flutter Demo",
    theme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
    home: const HomepageView(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyemailView(),
      mainRoute: (context) => const NotesView()
    },
  ));
}
