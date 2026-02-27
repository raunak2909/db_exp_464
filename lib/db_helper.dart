import 'dart:io';

import 'package:db_exp_464/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  ///private constructor
  DbHelper._();

  static DbHelper getInstance() {
    return DbHelper._();
  }

  Database? _mDB;
  static String DB_NAME = "notesDB.db";
  static String TABLE_NOTE = "note";
  static String COLUMN_NOTE_ID = "note_id";
  static String COLUMN_NOTE_TITLE = "note_title";
  static String COLUMN_NOTE_DESC = "note_desc";
  static String COLUMN_NOTE_CREATED_AT = "note_created_at";

  Future<Database> initDB() async {
    _mDB ??= await openDB();
    return _mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        ///create all tables here
        db.execute(
          "create table $TABLE_NOTE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_CREATED_AT text)",
        );
      },
    );
  }

  ///queries
  ///select
  Future<List<NoteModel>> getAllNotes() async {
    Database db = await initDB();

    List<Map<String, dynamic>> mNotes = await db.query(TABLE_NOTE);

    List<NoteModel> allNotes = [];

    ///mNotes.map((e) => allNotes.add(NoteModel.fromMap(e)));

    for(Map<String, dynamic> eachMap in mNotes){
      ///NoteModel eachNote = NoteModel.fromMap(eachMap);
      allNotes.add(NoteModel.fromMap(eachMap));
    }

    print("All Notes: $allNotes");
    return allNotes;
  }

  ///insert
  Future<bool> addNote({required NoteModel newNote}) async {
    Database db = await initDB();

    int rowsEffected = await db.insert(TABLE_NOTE, newNote.toMap());

    return rowsEffected > 0;
  }

  ///update
  Future<bool> updateNote({
    required String title,
    required String desc,
    required int id,
  }) async {
    var db = await initDB();
    int rowsEffected = await db.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc,
    }, where: '$COLUMN_NOTE_ID = $id');

    return rowsEffected > 0;
  }

  ///delete
  Future<bool> deleteNote({required int id}) async {
    var db = await initDB();

    int rowsEffected = await db.delete(
      TABLE_NOTE,
      where: '$COLUMN_NOTE_ID = ?',
      whereArgs: ['$id'],
    );

    return rowsEffected > 0;
  }
}
