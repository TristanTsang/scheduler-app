import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:improvement_journal/extensions.dart';
import '../models/journalEntry.dart';

class JournalData extends ChangeNotifier {
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

  void addPrompt(String text) {
    journalPrompts.add(text);
    notifyListeners();
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
      notifyListeners();
    }
  }

  List<String> get journalPrompts => _journalPrompts;

  void updateJournal() {
    notifyListeners();
  }
}
