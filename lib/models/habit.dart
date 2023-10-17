import 'dart:collection';
import 'package:improvement_journal/extensions.dart';

class Habit {
  int highestStreak =0;
  late String _name;
  final _dateSet =
      HashSet<DateTime>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  },hashCode: (DateTime date) {
        return int.tryParse("${date.year}${date.month}${date.day}")!;
      });
  bool _tracked = true;

  Habit(String name) {
    _name = name;
  }

  void untrack(){
    _tracked = false;
  }
  void track(){
    _tracked =true;
  }

  addDate(DateTime date) {
    dateSet.add(date);
  }

  removeDate(DateTime date) {
    dateSet.remove(date);
  }

  String get name => _name;
  bool get tracked => _tracked;

  set name(String value) {
    _name = value;
  }

  int getStreak(DateTime date) {
    int streak =0;

    while(dateSet.contains(date.subtract(Duration(days: 1 +streak)))){
      streak++;
    }

    if(dateSet.contains(date))
      streak++;
    if(streak>highestStreak){
      highestStreak = streak;
    }
    return streak;
  }

  HashSet<DateTime> get dateSet => _dateSet;



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit && other.name.toLowerCase() == name.toLowerCase();
}
