import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nothing_notes/services/db_exceptions.dart';

class NotesService {
  Database? _db;

  Database get _getDatabase {
    return _db!;
  }

  Future<bool> close() async {
    if (_db == null) {
      throw DatabaseNotOpenedDBException();
    }

    await _db?.close();
    _db = null;

    return true;
  }

  Future<bool> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenDBException;
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(userQuery);

      await db.execute(noteQuery);

      return true;
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDBException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabase;
    final results = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExistsDBException();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabase;

    final results = await db.query(
      userTable,
      where: 'email = ?',
      limit: 1,
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserNotFoundDBException();
    }

    return DatabaseUser.fromRow(results[0]);
  }

  Future<bool> deletUser({required String email}) async {
    final Database db = _getDatabase;
    final deletedCount = await db.delete(
      userTable,
      where: 'email == ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserDBException();
    }

    return true;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabase;
    final results = await db.query(
      notesTable,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      throw CouldNotFindNotesDBException();
    }
    return DatabaseNote.fromRow(results.first);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabase;
    final results = await db.query(notesTable);

    if (results.isEmpty) {
      throw CouldNotFindNotesDBException();
    }

    return results.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabase;

    final dbuser = await getUser(email: owner.email);

    if (owner != dbuser) {
      throw UserNotFoundDBException();
    }

    String text = "";
    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      contentColumn: text,
      syncedColumn: 1,
    });

    return DatabaseNote(
      id: noteId,
      userId: owner.id,
      content: text,
      synced: true,
    );
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String updatedContent}) async {
    final db = _getDatabase;

    await getNote(id: note.id);

    final updatedCount = await db.update(notesTable, {
      contentColumn: updatedContent,
      syncedColumn: false,
    });

    if (updatedCount == 0) {
      throw CouldNotUpdateNoteDBException();
    }

    return await getNote(id: note.id);
  }

  Future<bool> deleteAllNotes() async {
    final db = _getDatabase;
    await db.delete(notesTable);

    return true;
  }

  Future<bool> deleteNote({required int id}) async {
    final db = _getDatabase;

    final deletedCount = await db.delete(
      notesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw NoteNotFoundDBException();
    }

    return true;
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID = $id, Email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String content;
  bool synced = false;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.content,
    required this.synced,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        content = map[contentColumn] as String,
        synced = (map[syncedColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Notes, ID = $id, User ID = $userId, Content = $content, Synced = $synced";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const String dbName = "notes.db";
const String notesTable = "Note";
const String userTable = "User";
const String idColumn = "ID";
const String emailColumn = "Email";
const String userIdColumn = "User ID";
const String contentColumn = "Content";
const String syncedColumn = "Synced";
const userQuery = '''
CREATE TABLE IF NOT EXISTS "User" (
  "ID"	INTEGER NOT NULL,
  "Email"	INTEGER NOT NULL UNIQUE,
  PRIMARY KEY("ID" AUTOINCREMENT)
);''';
const noteQuery = '''
CREATE TABLE "Note" (
  "ID"	INTEGER NOT NULL,
  "User ID"	INTEGER NOT NULL,
  "Content"	TEXT,
  "Synced"	BOOLEAN NOT NULL DEFAULT 'FALSE',
  PRIMARY KEY("ID" AUTOINCREMENT),
  FOREIGN KEY("User ID") REFERENCES "User"("ID")
)''';
