import 'dart:io';

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
  String DB_NAME = "notesDB.db";
  String TABLE_NOTE = "note";
  String COLUMN_NOTE_ID = "note_id";
  String COLUMN_NOTE_TITLE = "note_title";
  String COLUMN_NOTE_DESC = "note_desc";
  String COLUMN_NOTE_CREATED_AT = "note_created_at";

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
  ///insert
  Future<bool> addNote({required String title, required String desc}) async{
    Database db = await initDB();

    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
      COLUMN_NOTE_CREATED_AT : DateTime.now().millisecondsSinceEpoch
    });

    return rowsEffected>0;
  }
  ///update
  ///delete
}
