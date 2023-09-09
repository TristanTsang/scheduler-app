class Habit{


  late String _name;
  int _streak = 0;
  DateTime _lastUpdated = DateTime.now();

  habit(String name){
    _name =name;
  }


  int get streak => _streak;

  String get name => _name;

  DateTime get lastUpdated => _lastUpdated;


  set name(String value) {
    _name = value;
  }

  set streak(int value) {
    _streak = value;
  }

  set lastUpdated(DateTime value) {
    _lastUpdated = value;
  }


}