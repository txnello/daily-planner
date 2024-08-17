import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  var _db = null;

  DatabaseHelper._internal();

  // check if table already exists
  Future<bool> tableExists(String tableName) async {
    Database db = await instance.db;
    var result = await db.query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    return result.isNotEmpty;
  }

  // init the internal database
  initDB() async {
    if (_db == null) {
      _db = await openDatabase('tasksDatabase.db');

      if (await tableExists("tasks") == false) {
        Database db = await instance.db;
        await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, date TEXT, time TEXT, active INTEGER, checked INTEGER)');
      }
    }
  }

  Future<Database> get db async {
    if (_db == null) {
      await initDB();
    }
    return _db;
  }

  /* Methods */

  Future<int> insertTask(String task, String date, String time) async {
    Database db = await instance.db;
    var id = await db.insert('tasks', {'task': task, 'date': date, 'time': time, 'active': 1, 'checked': 0});
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllTasks(String date) async {
    Database db = await instance.db;
    var tasks = await db.query('tasks', where: 'active = ? AND date = ?', whereArgs: [1, date], orderBy: 'time');
    return tasks;
  }

  Future<void> deleteTask(int id) async {
    Database db = await instance.db;
    await db.update('tasks', {'active': 0}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> checkTask(int id, int status) async {
    Database db = await instance.db;
    await db.update('tasks', {'checked': status}, where: 'id = ?', whereArgs: [id]);
  }
}
