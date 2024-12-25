import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nothing_notes/constants/routes.dart';
import 'package:nothing_notes/services/auth_service.dart';
import 'package:nothing_notes/services/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteOrSaveNote();
    _textController.dispose();
    super.dispose();
  }

  Future<DatabaseNote?> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser;

    if (currentUser?.email == null) {
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
      return null;
    }

    DatabaseUser? owner;
    try {
      owner = await _notesService.getUser(email: currentUser!.email!);
    } catch (e) {
      return null;
    }

    final note = await _notesService.createNote(owner: owner);
    return note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new Note"),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _deleteOrSaveNote() async {
    final note = _note;
    final text = _textController.text;
    if (note == null) return;

    if (text.isEmpty) {
      await _notesService.deleteNote(id: note.id);
    } else {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }
}
