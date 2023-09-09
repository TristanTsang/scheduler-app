
class Task {
  late String _taskName;
  String? _description;
  bool _done = false;
  DateTime? _dueDate;
  String? _label;
  String? _priority;
  Task({required String? taskName, String? description, DateTime? dueDate, String? label, String? priority}){
    _taskName = taskName!;
    _description = description;
    _dueDate =dueDate;
    _label = label;
    _priority = priority;
  }

  String? get label => _label;

  String? get description => _description;

  String ?get priority => _priority;

  DateTime? get dueDate => _dueDate;

  String get taskName => _taskName;

  bool get done => _done;

  void toggleDone(){
    _done = !done;
  }

  void setDueDate(DateTime date){
    _dueDate =date;
  }
  void setName(String name){
    _taskName = name;
  }




}