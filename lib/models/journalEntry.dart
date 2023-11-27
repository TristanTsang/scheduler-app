import 'dart:collection';
import 'dart:convert';

import 'package:improvement_journal/models/task.dart';

class JournalEntry {
  late List<String> _journalPrompts;
  late String _jsonJournalString;

  JournalEntry(List<String> journalPrompts){
    _journalPrompts = journalPrompts;
    List<Map<String, dynamic>> jsonFile = <Map<String, dynamic>>[];

    for(String prompt in _journalPrompts){
      jsonFile.add({'insert': '$prompt\n', 'attributes': {"bold": true, "size": "20"}});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
    }
    _jsonJournalString = jsonEncode(jsonFile);
  }

  void editFile( String text){
    _jsonJournalString = text;
  }

  String getFile(){
    return _jsonJournalString;
  }

  List<String> get journalPrompts => _journalPrompts;
}
