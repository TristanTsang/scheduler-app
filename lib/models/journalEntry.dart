import 'dart:convert';
import 'JournalPrompt.dart';

class JournalEntry {
  late String _jsonJournalString;
  int? id;

  JournalEntry(List<JournalPrompt> journalPrompts){

    List<Map<String, dynamic>> jsonFile = <Map<String, dynamic>>[{'insert': '\n'}];

    for(JournalPrompt prompt in journalPrompts){
      jsonFile.add({'insert': '${prompt.text}\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
      jsonFile.add({'insert' : '\n'});
    }
    _jsonJournalString = jsonEncode(jsonFile);
  }

  Map<String, Object?> toMap(){
    var map = <String, Object?>{
      'journalString': _jsonJournalString,
   };
    if(id != null) {
      map['id'] = id;
    }
    return map;
  }
  JournalEntry.fromMap(Map<String, dynamic> map){
    id = map['id'];
    _jsonJournalString = map['journalString'];

  }

  void editFile( String text){
    _jsonJournalString = text;
  }

  String getFile(){
    return _jsonJournalString;
  }


}
