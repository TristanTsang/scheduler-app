import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';

import '../models/TaskList.dart';

class TaskData extends ChangeNotifier {
  HashMap<DateTime, TaskList> TaskMap =
      HashMap<DateTime, TaskList>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.parse('${date.day}${date.month}${date.year}');
  });

  TaskList getTaskList(DateTime date){
    _updateDate(date);
    return TaskMap[date]!;
  }

  void updateTaskList(){
    notifyListeners();
  }

  void _updateDate(DateTime date){
    TaskMap.putIfAbsent(date, () => TaskList());
  }
}
