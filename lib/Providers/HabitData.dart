import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import '../Services/sqlite_service.dart';
import '../models/habit.dart';
import '../models/journalEntry.dart';

class HabitData extends ChangeNotifier {
  final HashMap<DateTime, HashSet<Habit>> _dateMap =
      HashMap<DateTime, HashSet<Habit>>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, );
  final _allHabits = HashSet<Habit>();

  void addHabit(Habit habit) {
    _allHabits.add(habit);
    SqliteService.insertHabit(habit);
    print(SqliteService.habits());
    notifyListeners();
  }

  void removeHabit(Habit habit) {
    _allHabits.remove(habit);
    notifyListeners();
  }

  // Call after every change to a Habit object in Habit Data that should
  // Be reflected by UI changes in the app
  void updateHabit(){
    notifyListeners();
  }

  HashSet<Habit>? getHabits(DateTime date) {
    _updateDate(date);
    return _dateMap[date];
  }

  HashSet<Habit> getAllHabits() {
    return _allHabits;
  }

   void _updateDate(DateTime date) {
     var mySet = HashSet<Habit>();
     for(Habit item in _allHabits){
       if(item.isTracked(date) == true){
         mySet.add(item);
       }
     }
     _dateMap[date]= mySet;
  }
}
