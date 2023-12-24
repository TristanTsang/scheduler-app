import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import '../Services/sqlite_service.dart';
import '../models/habit.dart';

class HabitData extends ChangeNotifier {

  final _allHabits = HashSet<Habit>();

  void addHabit(Habit habit) {
    _allHabits.add(habit);
    SqliteService.insertHabit(habit);
    notifyListeners();
  }

  void loadHabits(List<Habit> list){
    _allHabits.addAll(list);
  }


  void removeHabit(Habit habit) {
    _allHabits.remove(habit);
    for(DateTime date in habit.dateSet){
      SqliteService.deleteHabitDate(habit, DateTimeExtensions.stringFormat(date));
    }
    SqliteService.deleteHabit(habit);
    notifyListeners();
  }

  // Call after every change to a Habit object in Habit Data that should
  // Be reflected by UI changes in the app
  void updateHabit(){
    notifyListeners();
  }

  HashSet<Habit>? getHabits(DateTime date) {
    HashSet<Habit>? mySet = HashSet<Habit>();
    for (Habit habit in _allHabits){
      if(habit.isTracked(date))
        mySet.add(habit);
    }
    if(mySet.isEmpty) mySet = null;

    return mySet;

  }

  HashSet<Habit> getAllHabits() {
    return _allHabits;
  }


}
