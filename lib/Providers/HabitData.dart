import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import '../models/habit.dart';
import '../models/journalEntry.dart';

class HabitData extends ChangeNotifier {

  final HashMap<DateTime, JournalEntry> _journalEntryMap =
  HashMap<DateTime, JournalEntry>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.parse('${date.day}${date.month}${date.year}');
  });

  final List<String> _journalPrompts = [
    "What am I grateful for today?",
    "What difficulties or worries will I overcome today?",
    "How can I use today to pursue my purpose or passions?",

    "Reflect on today's events. What went well and what went wrong?",
    "How will I improve tomorrow",
    "Jot down any extra thoughts, emotions, or stories from today",
  ];

  JournalEntry getJournal(DateTime date) {
    updateDate(date);
    return _journalEntryMap[date]!;
  }

  void updateDate(DateTime date) {
    _journalEntryMap.putIfAbsent(
        date, () => JournalEntry(_journalPrompts));
  }

  void updateJournal() {
    notifyListeners();
  }

  final HashMap<DateTime, HashSet<Habit>> _dateMap =
      HashMap<DateTime, HashSet<Habit>>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, );
  final _allHabits = HashSet<Habit>();

  void addHabit(Habit habit) {
    _allHabits.add(habit);
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
