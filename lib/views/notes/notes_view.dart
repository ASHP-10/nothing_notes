import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/constants/enums.dart';
import 'package:nothing_notes/services/auth_service.dart';
import 'package:nothing_notes/services/navigation_service.dart';
import 'package:nothing_notes/services/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            onPressed: () {
              NavigationService.navigateTo(newNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuItem>(
            itemBuilder: (context) {
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
            onSelected: (value) async {
              switch (value) {
                case MenuItem.logout:
                  {
                    if (await logOutPopUpDialog(context)) {
                      //await _notesService.close();
                      await AuthService.firebase().logOut();
                      NavigationService.navigateAndRemoveUntil(loginRoute);
                    }
                    break;
                  }
                case MenuItem.settings:
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text(
                        "Waiting for all notes",
                        style: TextStyle(color: Colors.white),
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

Future<bool> logOutPopUpDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to Sign Out?"),
          actions: [
            TextButton(
                onPressed: () => {Navigator.of(context).pop(false)},
                child: const Text("Cancel")),
            TextButton(
                onPressed: () => {Navigator.of(context).pop(true)},
                child: const Text("Yes"))
          ],
        );
      }).then(
    (value) => value ?? false,
  );
}
