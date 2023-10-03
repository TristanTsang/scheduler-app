class Habit {
  late String _name;
  bool _value = false;

  Habit(String name) {
    _name = name;
  }

  void checkTask() {
    _value = !_value;
  }

  bool get value => _value;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Habit && (other as Habit).name.toLowerCase() == name.toLowerCase();
}
