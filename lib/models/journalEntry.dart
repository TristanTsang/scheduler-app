import 'package:improvement_journal/models/task.dart';

class JournalEntry {
  late DateTime _date;
  List<Task> _toDoList = [];
  String _journalText = "";

  JournalEntry({required DateTime date,List<Task>? toDoList}) {
    _date = date;
    _toDoList = toDoList!=null? toDoList : [];
  }
  int get numCompletedTasks {
    int num =0;
    for(int i=0;i< _toDoList.length;i++){
      if(_toDoList[i].done){
        num++;
      }
    }
    return num;
  }

  String get journalText => _journalText;

  List<Task> get toDoList => _toDoList;
  void addTask(Task task) {
    _toDoList.add(task);
  }

  void removeTask(int index) {
    _toDoList.remove(index);
  }
}
