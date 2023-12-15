import 'package:flutter/cupertino.dart';

import '../Services/sqlite_service.dart';

class AppData extends ChangeNotifier{
  DateTime _selectedDay = DateTime.now();
  late SqliteService _sqliteService;
  void changeSelectedDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }
  DateTime getSelectedDay() {
    return _selectedDay;
  }

}