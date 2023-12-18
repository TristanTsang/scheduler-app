import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/extensions.dart';

import '../models/TaskList.dart';
import '../models/task.dart';

class TaskData extends ChangeNotifier {
  HashMap<DateTime, TaskList> _TaskMap =
      HashMap<DateTime, TaskList>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.parse('${date.day}${date.month}${date.year}');
  });

  TaskList getTaskList(DateTime date){
    _updateDate(date);
    return _TaskMap[date]!;
  }

  void updateTaskList(){
    notifyListeners();
  }
  
  void addTask(Task task, DateTime date){
    _updateDate(date);
    _TaskMap[date]!.addTask(task);
    SqliteService.insertTask(task, DateTimeExtensions.stringFormat(date));
  }

  void _updateDate(DateTime date){
    _TaskMap.putIfAbsent(date, () => TaskList());
  }
  void loadTasks(Map<DateTime, TaskList> other){
    _TaskMap.addAll(other);
  }
}
