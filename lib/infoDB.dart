import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class InfoDB {
  static final _databaseName = "Info.db";
  static final _databaseVersion = 1;
  static final table = 'info';
  static final id = 'id';
  static final date = 'date';
  static final temp = 'temp';
  static final status = 'status';

  InfoDB._privateConstructor();
  static final InfoDB instance = InfoDB._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $id INTEGER PRIMARY KEY,
            $date TEXT,
            $temp TEXT,
            $status TEXT
          )
          ''');
  }
}
