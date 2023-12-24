import 'dart:collection';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/extensions.dart';

class Habit {
  int _highestStreak = 0;

  void setEndDate(DateTime value) {
    _endDate = value;
  }
  int? id;
  late String _name;
  late DateTime _startDate;
  late DateTime _endDate;

  DateTime get startDate => _startDate;
  final _dateSet = HashSet<DateTime>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.tryParse("${date.year}${date.month}${date.day}")!;
  });
  final bool _tracked = true;

  int get highestStreak => _highestStreak;

  Habit(String name, int duration) {

    _name = name;
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(Duration(days: duration-1));
  }

  Habit.fromDates(String name, DateTime startDate, DateTime endDate) {
    _name = name;
    _startDate = startDate;
    _endDate = endDate;
  }

  Habit.fromMap(Map<String, dynamic> map){
    id = map['id'];
    _name = map['name'];
    _startDate = DateTimeExtensions.formatStringToDate(map['startDate']);
    _endDate = DateTimeExtensions.formatStringToDate(map['endDate']);
  }

  Map<String, dynamic> toMap(){
    var map = <String, Object?>{
      'name': _name,
      'startDate':  DateTimeExtensions.stringFormat(_startDate),
      'endDate': DateTimeExtensions.stringFormat(_endDate),
    };
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
  bool isTracked(DateTime date) {
    return ((date.isAfter(_startDate) || date.isSameDate(_startDate)) && date.dateIsBefore(_endDate) && date.dateIsBefore(DateTime.now().add(const Duration(days: 1))));
  }

  bool isDone(DateTime date) {
    return _dateSet.contains(date);
  }

  addDate(DateTime date) {
    dateSet.add(date);
    SqliteService.insertHabitDate(this, DateTimeExtensions.stringFormat(date));
  }

  removeDate(DateTime date) {
    dateSet.remove(date);

    SqliteService.deleteHabitDate(this, DateTimeExtensions.stringFormat(date));
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
  @override
  String toString() {
    return 'Habit{id: $id, name: $name, startDate: ${DateTimeExtensions.stringFormat(_endDate)}, endDate: ${DateTimeExtensions.stringFormat(_endDate)}';
  }
}
