import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:point_tracker/model/character.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._createInstance();
  String tblCharacter = 'char';
  String colId = 'id';
  String colName = 'name';
  String colPoints = 'points';

  DbHelper._createInstance();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database? _db;

  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db!;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}chars.db";
    var dbChars = await openDatabase(path, version: 1, onCreate: _onCreateDb);
    return dbChars;
  }

  void _onCreateDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tblCharacter($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT,'
        ' $colPoints INTEGER)');
  }

  Future<int> insertCharacter(Character character) async {
    Database db = await this.db;
    var result = await db.insert(tblCharacter, character.toMap());
    return result;
  }

  Future<List> getCharacters() async {
    Database db = await this.db;
    //var result = await db.rawQuery("SELECT * FROM $tblCharacter order by $colPoints ASC");
    var result = await db.query(tblCharacter, orderBy: '$colPoints DESC');
    return result;
  }

  // Future<int> getCount() async {
  //   Database db = await this.db;
  //   var result = Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT (*) from $tblCharacter')
  //   );
  //   return result;
  // }

  Future<int> updateCharacter(Character character) async {
    var db = await this.db;
    var result = await db.update(tblCharacter, character.toMap(),
        where: '$colId = ?', whereArgs: [character.id]);
    return result;
  }

  Future<int> deleteCharacter(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblCharacter WHERE $colId = $id");

    return result;
  }

  Future<List<Character>> getCharacterList() async {
    var characterMapList = await getCharacters();
    int count = characterMapList.length;

    List<Character> characterList = [];
    for (int i = 0; i < count; i++) {
      characterList.add(Character.fromMap(characterMapList[i]));
    }
    return characterList;
  }
}
