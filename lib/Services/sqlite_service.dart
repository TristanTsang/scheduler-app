import 'package:improvement_journal/extensions.dart';
import 'package:improvement_journal/models/journalEntry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/JournalPrompt.dart';
import '../models/TaskList.dart';
import '../models/habit.dart';
import '../models/task.dart';

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

        await database.execute(
          'CREATE TABLE dates(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT)',
        );
        List<JournalPrompt> _journalPrompts = [
          JournalPrompt("What am I grateful for today?"),
          JournalPrompt("What difficulties or worries will I overcome today?"),
          JournalPrompt("How can I use today to pursue my purpose or passions?"),
          JournalPrompt("Reflect on today's events. What went well and what went wrong?"),
          JournalPrompt("How will I improve tomorrow"),
          JournalPrompt("Jot down any extra thoughts, emotions, or stories from today"),
        ];
        for(JournalPrompt prompt in _journalPrompts) {
          prompt.id = await database.insert(
              'journalPrompts', {'prompt': prompt.text},
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        SqliteService.insertDay(DateTimeExtensions.stringFormat(DateTime.now()));
      },
      version: 1,
    );
  }

  static Future<void> insertHabit(Habit habit) async {
    final Database db = await initializeDB();
    habit.id = await db.insert('habits', habit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Habit>> habits() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (index) {
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

  static Future<void> deleteHabit(Habit habit) async {
    final Database db = await initializeDB();
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  static Future<void> insertHabitDate(Habit habit, String date) async {
    final Database db = await initializeDB();
    await db.insert('habitDates', {'dateTime': date, 'habit_id': habit.id},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<DateTime>> habitDates(Habit habit) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db
        .query('habitDates', where: 'habit_id = ?', whereArgs: [habit.id]);
    return List.generate(maps.length, (index) {
      return DateTimeExtensions.formatStringToDate((maps[index]['dateTime']));
    });
  }

  static Future<void> deleteHabitDate(Habit habit, String date) async {
    final Database db = await initializeDB();
    await db.delete(
      'habitDates',
      where: 'habit_id = ? AND dateTime = ?',
      whereArgs: [habit.id, date],
    );
  }

  static insertJournalEntry(JournalEntry journalEntry, String date) async {
    final Database db = await initializeDB();
    journalEntry.id = await db.insert(
        'journals', {'journalString': journalEntry.getFile(), 'dateTime': date},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updateJournal(JournalEntry journalEntry, String date) async {
    final Database db = await initializeDB();
    await db.update(
      'journals',
      {'journalString': journalEntry.getFile(), 'dateTime': date},
      where: 'id = ?',
      whereArgs: [journalEntry.id],
    );
  }

  static Future<void> deleteJournal(JournalEntry journalEntry) async {
    final Database db = await initializeDB();
    await db.delete(
      'journals',
      where: 'id = ?',
      whereArgs: [journalEntry.id],
    );
  }

  static Future<Map<DateTime, JournalEntry>> journalsMap() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('journals');
    var map = <DateTime, JournalEntry>{};
    for (var element in maps) {
      map[DateTimeExtensions.formatStringToDate(element['dateTime'])] =
          JournalEntry.fromMap(element);
    }
    return map;
  }

  static insertTask(Task task, String date) async {
    final Database db = await initializeDB();
    task.id = await db.insert(
        'tasks', {'name': task.taskName, 'dateTime': date, "done" :  task.done? 1: 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updateTask(Task task, String date) async {
    final Database db = await initializeDB();
    await db.update(
      'tasks',
      {'name': task.taskName,'done': task.done? 1: 0, 'dateTime': date},
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(Task task) async {
    final Database db = await initializeDB();
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<Map<DateTime, TaskList>> taskListsMap() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    var map = <DateTime, TaskList>{};
    
    for (var element in maps) {
      DateTime date =DateTimeExtensions.formatStringToDate(element['dateTime']);
      map.putIfAbsent(date, () => TaskList());
      map[date]!.addTask(Task.fromMap(element));
    }
    return map;
  }


  static insertPrompt(JournalPrompt prompt) async {
    final Database db = await initializeDB();
    prompt.id = await db.insert(
        'journalPrompts', {'prompt': prompt.text},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static updatePrompt(JournalPrompt prompt) async {
    final Database db = await initializeDB();
    await db.update(
      'JournalPrompts',
      {'prompt': prompt.text,},
      where: 'id = ?',
      whereArgs: [prompt.id],
    );
  }

  static Future<void> deletePrompt(JournalPrompt prompt) async {
    final Database db = await initializeDB();
    await db.delete(
      'JournalPrompts',
      where: 'id = ?',
      whereArgs: [prompt.id],
    );
  }

  static Future<List<JournalPrompt>> journalPrompts() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db.query('journalPrompts');
    return List.generate(maps.length, (index) {
      return JournalPrompt.fromMap(maps[index]);
    });
  }

  /*
  static insertWeek(DateTime date) async {
    final Database db = await initializeDB();
    var queryResult = await db.rawQuery('SELECT * FROM dates WHERE date="$date"');
    if(queryResult.isEmpty){
      for(int i =0; i<7;i++){
        String newDate = DateTimeExtensions.stringFormat(DateTimeExtensions.mostRecentMonday(date).add(Duration(days: i)));
        await db.insert(
            'dates', {'date': newDate},
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }*/
  static insertDay(String date) async {
    final Database db = await initializeDB();
    await db.insert(
        'dates', {'date': date},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<DateTime> startDate() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> maps = await db
        .query('dates', where: 'id = ?', whereArgs: [1]);
    return DateTimeExtensions.formatStringToDate(maps[0]['date']);
  }

}
