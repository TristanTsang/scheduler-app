extension DateTimeExtensions on DateTime {
  bool isSameDate(DateTime other) {
    return day == other.day &&  month == other.month  && year == other.year;
  }

  static DateTime mostRecentMonday(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday - 1));
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  bool dateIsBefore(DateTime other){
    if(year<other.year) return true;
    if(year == other.year && month< other.month) return true;
    if(year == other.year && month == other.month && day< other.day) return true;
    else return false;
  }

}
