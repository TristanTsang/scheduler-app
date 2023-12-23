import 'package:flutter/cupertino.dart';

import '../Services/sqlite_service.dart';

class AppData extends ChangeNotifier{
  DateTime _selectedDay = DateTime.now();
  late DateTime _startDate;

  void loadInitialDate(DateTime date)  {
     _startDate = date;
  }
  void changeSelectedDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }

  DateTime getSelectedDay() {
    return _selectedDay;
  }

  DateTime getStartDate() {
    return _startDate;
  }
}