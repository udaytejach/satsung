import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mirror_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_recordings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        recordingPath TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertRecording(Map<String, dynamic> recording) async {
    final db = await database;
    return await db.insert('user_recordings', recording);
  }

  Future<List<Map<String, dynamic>>> fetchRecordings() async {
    final db = await database;
    return await db.query('user_recordings');
  }
}
