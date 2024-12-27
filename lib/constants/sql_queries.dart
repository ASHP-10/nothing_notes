const dbName = "notes.db";
const noteTableName = "notes";
const userTableName = "users";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const syncedColumn = "synced";

const userTableQuery = '''
  CREATE TABLE IF NOT EXISTS "users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "email" TEXT NOT NULL UNIQUE
  )''';

const noteTableQuery = '''
  CREATE TABLE IF NOT EXISTS "notes" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "text" TEXT NOT NULL, 
    "synced" INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY("user_id") REFERENCES "user"("id")
  )''';
