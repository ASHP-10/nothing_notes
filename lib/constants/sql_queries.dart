const dbName = "notes.db";
const noteTableName = "note";
const userTableName = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "content";
const syncedColumn = "synced";

const userTableQuery = '''
  CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
)''';
const noteTableQuery = '''
  CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"content"	TEXT,
	"synced"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("synced") REFERENCES "user"("id")
)''';
