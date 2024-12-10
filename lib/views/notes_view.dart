import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';

enum MenuItem {
  logout,
  settings
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.redAccent,
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: (value) async {
              switch(value) {
                case MenuItem.logout: {
                  if(await showLogOut(context)) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  break;
                }
                case MenuItem.settings:

              }
            }, itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: MenuItem.logout,
                  child: Text("Log Out"),
                ),
                PopupMenuItem(
                  value: MenuItem.settings,
                  child: Text("Settings"),
                )
              ];
            },
          )
        ],
      ),
      body: Text("Notes"),    
    );
  }
}

Future<bool> showLogOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to Sign Out?"),
        actions: [
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(false)
            }, 
            child: const Text("Cancel")
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(true)
            }, 
            child: const Text("Yes")
          )
        ],
      );
    }
  ).then((value) => value ?? false,);
}