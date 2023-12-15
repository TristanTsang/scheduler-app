import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/habit.dart';

class SqliteService {
  static Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, startDate TEXT, endDate TEXT, highestStreak INTEGER)',
        );
        await database.execute(
          'CREATE TABLE journals(id INTEGER PRIMARY KEY AUTOINCREMENT, journalString TEXT, dateTime TEXT)',
        );
        await database.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dateTime TEXT, done INTEGER)',
        );
        await database.execute(
          'CREATE TABLE habitDates(id INTEGER PRIMARY KEY AUTOINCREMENT, dateTime TEXT, habit_id INTEGER, FOREIGN KEY(habit_id) REFERENCES habits(id))',
        );
        await database.execute(
          'CREATE TABLE journalPrompts(id INTEGER PRIMARY KEY AUTOINCREMENT, prompt TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertHabit(Habit habit) async {
    final Database db = await initializeDB();
    habit.id = await db.insert('habits', habit.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Habit>> habits() async{
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (index){
      return Habit.fromMap(maps[index]);
    });
  }

  static Future<void> updateHabit(Habit habit) async {
    final Database db = await initializeDB();
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }
  static Future<void> deleteHabit(Habit habit) async{
    final Database db = await initializeDB();
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs:  [habit.id],
    );
  }
}