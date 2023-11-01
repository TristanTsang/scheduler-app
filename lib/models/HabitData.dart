import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import 'habit.dart';

class HabitData extends ChangeNotifier {
  final HashMap<DateTime, Set<Habit>> _dateMap =
      HashMap<DateTime, Set<Habit>>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, );
  var allHabits = <Habit>[];

  void addHabit(Habit habit, DateTime date) {
    allHabits.add(habit);
    _dateMap[date]!.add(habit);
    notifyListeners();
  }

  void removeHabit(Habit habit) {
    allHabits.remove(habit);
    notifyListeners();
  }

  bool isTrue(DateTime date, Habit habit) {
    return habit.dateSet.contains(date);
  }

  void trackHabit(Habit habit) {
    habit.track();
    notifyListeners();
  }
  void untrackHabit(Habit habit,) {
    habit.untrack();
    notifyListeners();
  }
  Set<Habit> getHabits(DateTime date) {
    return _dateMap[date]!;
  }

  List<Habit> getAllHabits() {
    return allHabits;
  }

  void markHabitDate(DateTime date, Habit habit) {
    if (isTrue(date, habit)) {
      print(1);
      habit.removeDate(date);
    } else {
      print(2);
      habit.addDate(date);
    }
    notifyListeners();
  }

  void updateDate(DateTime date) {
      Set<Habit> mySet = <Habit>{};
      for (Habit item in allHabits) {
        if (item.tracked && !date.isBefore(DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day))) {
          mySet.add(item);
        }
      }

      if(!date.isBefore(DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day))){
        _dateMap[date] = mySet;
      }else{
        _dateMap.putIfAbsent(date, () {
          return <Habit>{};
        });
      }


  }

  void deleteHabit(Habit habit) {
    allHabits.remove(habit);
    _dateMap.forEach((key, value) {
      _dateMap[key]!.remove(value);
    });
  }
}
