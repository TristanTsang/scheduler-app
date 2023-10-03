import 'dart:collection';
import 'package:improvement_journal/extensions.dart';

import 'habit.dart';

class HabitTracker {
  HashMap<Habit, HashSet<DateTime>> _habitMap =
      HashMap<Habit, HashSet<DateTime>>();
  HashMap<DateTime, Set<Habit>> _dateMap =
      HashMap<DateTime, Set<Habit>>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  });
  var currentHabits = <Habit>[];

  void addHabit(Habit habit) {
    _habitMap.addAll({
      habit: HashSet<DateTime>(equals: (DateTime a, DateTime b) {
        return a.isSameDate(b);
      })
    });
    currentHabits.add(habit);
  }

  void removeHabit(String habit) {
    currentHabits.remove(habit);
  }
  void updateDate(DateTime date) {
    _dateMap.putIfAbsent(date, () {
      Set<Habit> mySet = <Habit>{};
      for (Habit item in currentHabits) {
        mySet.add(Habit(item.name));
      }
      return mySet;
    });
  }

  int getStreak(Habit habit) {
    int streak = 0;
    if (_habitMap[habit]!.contains(DateTime.now()))
      streak++;
    while (_habitMap[habit]!.contains(DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day - 1 - streak))) {
      streak++;
    }
    return streak;
  }

  void deleteHabit(Habit habit){
    _habitMap.remove(habit);
    currentHabits.remove(habit);
    _dateMap.forEach((key, value){
      _dateMap[key]!.remove(value);
    });
  }

  void checkHabit(DateTime date, Habit habit){
    habit.checkTask();
    _habitMap[habit]!.add(date);
  }

  Set<Habit> getHabits(DateTime date) => _dateMap[date]!;
  Set<Habit> getDates(Habit habit) => _dateMap[habit]!;
}
