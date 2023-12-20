import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/extensions.dart';
import '../models/JournalPrompt.dart';
import '../models/journalEntry.dart';

class JournalData extends ChangeNotifier {
  final HashMap<DateTime, JournalEntry> _journalEntryMap =
      HashMap<DateTime, JournalEntry>(equals: (DateTime a, DateTime b) {
    return a.isSameDate(b);
  }, hashCode: (DateTime date) {
    return int.parse('${date.day}${date.month}${date.year}');
  });


  final List<JournalPrompt> _journalPrompts = [];

  void addPrompt(String text) {
    var prompt = JournalPrompt(text);
    journalPrompts.add(prompt);
    SqliteService.insertPrompt(prompt);

    notifyListeners();
  }
  void loadPrompts(List<JournalPrompt> list) {
    for (var element in list) {_journalPrompts.add(element);}
  }


  void loadJournals(Map<DateTime, JournalEntry> other){
    _journalEntryMap.addAll(other);
  }

  LinkedHashMap<DateTime, JournalEntry> getSortedJournalMap() {
    List mapKeys = _journalEntryMap.keys.toList(growable: false);
    mapKeys.sort((k1, k2) => k1.compareTo(k2));
    LinkedHashMap<DateTime, JournalEntry> newMap =
        new LinkedHashMap<DateTime, JournalEntry>();
    mapKeys.forEach((k1) {
      newMap[k1] = _journalEntryMap[k1]!;
    });
    return newMap;
  }

  JournalEntry getJournal(DateTime date) {
    updateDate(date);
    return _journalEntryMap[date]!;
  }

  void updateDate(DateTime date) {
    if(!_journalEntryMap.containsKey(date)){
      _journalEntryMap.putIfAbsent(date, () => JournalEntry(_journalPrompts));
      SqliteService.insertJournalEntry(_journalEntryMap[date]!, DateTimeExtensions.stringFormat(date));
    }
  }

  List<JournalPrompt> get journalPrompts => _journalPrompts;

  void updateJournal() {
    notifyListeners();
  }
}
