import 'package:improvement_journal/models/task.dart';

class TaskList {
  final List<Task> _tasks = <Task>[];

  List<Task> getTasks() {
    return _tasks;
  }

  int getLength() {
    return _tasks.length;
  }

  int numCompletedTasks() {
    int num = 0;
    for (Task task in _tasks) {
      if (task.done) {
        num++;
      }
    }
    return num;
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(Task task) {
    _tasks.remove(task);
  }


}
