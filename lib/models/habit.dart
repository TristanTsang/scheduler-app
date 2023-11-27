import 'dart:collection';
import 'package:improvement_journal/extensions.dart';

class Habit {
  int _highestStreak = 0;

  void setEndDate(DateTime value) {
    _endDate = value;
  }

  late String _name;
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime get startDate => _startDate;
  final _dateSet = HashSet<DateTime>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.tryParse("${date.year}${date.month}${date.day}")!;
  });
  bool _tracked = true;

  int get highestStreak => _highestStreak;

  Habit(String name, int duration) {
    _name = name;
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(Duration(days: duration));
  }

  Habit.fromDates(String name, DateTime startDate, DateTime endDate) {
    _name = name;
    _startDate = startDate;
    _endDate = endDate;
  }

  bool isTracked(DateTime date) {
    return ((date.isAfter(_startDate) || date.isSameDate(_startDate)) && date.dateIsBefore(_endDate) && date.dateIsBefore(DateTime.now().add(Duration(days: 1))));
  }

  bool isDone(DateTime date) {
    return _dateSet.contains(date);
  }

  addDate(DateTime date) {
    dateSet.add(date);
  }

  removeDate(DateTime date) {
    dateSet.remove(date);
  }

  String get name => _name;
  bool get tracked => _tracked;

  void setName(String value) {
    _name = value;
  }

  int getStreak(DateTime date) {
    int streak = 0;

    while (dateSet.contains(date.subtract(Duration(days: 1 + streak)))) {
      streak++;
    }

    if (dateSet.contains(date)) streak++;
    if (streak > _highestStreak) {
      _highestStreak = streak;
    }
    return streak;
  }

  int getAccuracy() {
    return ((_dateSet.length /
                (DateTimeExtensions.daysBetween(_startDate, DateTime.now()) +
                    1)) *
            100)
        .toInt();
  }

  HashSet<DateTime> get dateSet => _dateSet;

  DateTime get endDate => _endDate;
}
