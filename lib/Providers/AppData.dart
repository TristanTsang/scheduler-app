import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier{
  DateTime _selectedDay = DateTime.now();

  void changeSelectedDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }
  DateTime getSelectedDay() {
    return _selectedDay;
  }
}