import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:improvement_journal/models/task.dart';
import 'package:provider/provider.dart';

import 'habit.dart';
import 'journalEntry.dart';

class JournalData extends ChangeNotifier {

  DateTime _selectedDay = DateTime.now();
  LinkedHashMap<DateTime, JournalEntry> _journalEntryMap =
      LinkedHashMap<DateTime, JournalEntry>(equals: (DateTime a, DateTime b){
    return a.isSameDate(b);
  }, hashCode: (DateTime date){return int.parse('${date.day}${date.month}${date.year}');});

  void changeSelectedDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }

  JournalEntry getSelectedJournal() {
    _journalEntryMap.putIfAbsent(_selectedDay, () {
      return JournalEntry(date: _selectedDay);
    });
    return _journalEntryMap[_selectedDay]!;
  }

  void addTask(Task task) {
    getSelectedJournal().addTask(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    getSelectedJournal().toDoList.remove(task);
    notifyListeners();
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }
  void toggleDone(Task task){
    task.toggleDone();
    notifyListeners();
  }

}
