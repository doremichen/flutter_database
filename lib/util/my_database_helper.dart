///
/// Database helper
///
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



import 'package:flutter_database_app/model/my_note.dart';

class MydbHelper {
  // get my database helper instance
  static final MydbHelper _helper = MydbHelper.internal();

  factory MydbHelper() => _helper;

  final String tableNote = "noteTable";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnDescription = "description";

  // Database object
  static Database _db;

  MydbHelper.internal();

  // Callback: _onCreate
  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $tableNote($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)");
  }

  // initail databse
  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "Adam.db");

    var db = await openDatabase(path, version: 1, onCreate:  _onCreate);
    return db;
  }

  // Get db
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await _initDatabase();

    return _db;
  }

  // Save note
  Future<int> saveNote(MyNote note) async {
    var dbClient = await db;
    var ret = await dbClient.insert(tableNote, note.toMap());
    return ret;
  }

  // Query all notes
  Future<List> getAllNotes() async {
    var dbClient = await db;
    var ret = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    return ret.toList();
  }

  // Update Note
  Future<int> updateNote(MyNote note) async {
    var dbClient = await db;
    var ret = await dbClient.update(tableNote, note.toMap(), where: "$columnId = ?", whereArgs: [note.id]);
    return ret;
  }

  // Delete Note
  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    var ret = await dbClient.delete(tableNote, where: "$columnId = ?", whereArgs: [id]);
    return ret;
  }

  // close database
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

  // Get the specified note
  Future<MyNote> getNote(int id) async {
    var dbClient = await db;
    List<Map> map = await dbClient.query(tableNote,
      columns: [columnId, columnTitle, columnDescription],
      where: "$columnId = ?",
      whereArgs: [id]
    );

    if (map.length > 0) {
      return MyNote.fromMap(map.first);
    }

    return null;
  }

  // Get data number from database
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableNote"));
  }

}

