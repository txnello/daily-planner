import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  var _db = null;

  DatabaseHelper._internal();

  Future<bool> tableExists(String tableName) async {
    Database db = await instance.db;
    var result = await db.query('sqlite_master', where: 'name = ?', whereArgs: [tableName]);
    return result.isNotEmpty;
  }

  initDB() async {
    if (_db == null) {
      _db = await openDatabase('tasksDatabase.db');

      if (await tableExists("tasks") == false) {
        Database db = await instance.db;
        await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, date TEXT, time TEXT, active BOOLEAN, checked BOOLEAN)');
      }
    }
  }

  Future<Database> get db async {
    if (_db == null) {
      await initDB();
    }
    return _db;
  }

  Future<int> insertTask(String task, String date, String time) async {
    Database db = await instance.db;
    var id = await db.insert('tasks', {'task': task, 'date': date, 'time': time, 'active': true, 'checked': false});
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllTasks(String date) async {
    Database db = await instance.db;
    var tasks = await db.query('tasks', where: 'active = ? AND date = ?', whereArgs: [true, date], orderBy: 'time');
    return tasks;
  }

  Future<void> deleteTask(int id) async {
    Database db = await instance.db;
    await db.update('tasks', {'active': false}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> checkTask(int id, bool status) async {
    Database db = await instance.db;
    await db.update('tasks', {'checked': status}, where: 'id = ?', whereArgs: [id]);
  }
}
