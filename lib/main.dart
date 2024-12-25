import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/views/Notes/new_note_view.dart';
import 'package:nothing_notes/views/login_view.dart';
import 'package:nothing_notes/views/Notes/notes_view.dart';
import 'package:nothing_notes/views/register_view.dart';
import 'package:nothing_notes/views/verifyemail_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
    home: const LoginView(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyemailView(),
      mainRoute: (context) => const NotesView(),
      newNoteRoute: (context) => const NewNoteView(),
    },
  ));
}
