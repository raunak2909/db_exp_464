import 'db_helper.dart';

/// table note
class NoteModel {
  ///columns
  int? id;
  String title;
  String desc;
  int createdAt;

  ///default
  ///parameterized
  ///named
  ///factory

  NoteModel({
    this.id,
    required this.title,
    required this.desc,
    required this.createdAt
  });

  ///model to map
  Map<String, dynamic> toMap() {
    return {
      DbHelper.COLUMN_NOTE_TITLE: title,
      DbHelper.COLUMN_NOTE_DESC: desc,
      DbHelper.COLUMN_NOTE_CREATED_AT: createdAt.toString(),
    };
  }

  ///model from map NoteModel.fromMap(map)
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map[DbHelper.COLUMN_NOTE_ID],
        title: map[DbHelper.COLUMN_NOTE_TITLE],
        desc: map[DbHelper.COLUMN_NOTE_DESC],
        createdAt: int.parse(map[DbHelper.COLUMN_NOTE_CREATED_AT]));
  }
}