String getDayName(int weekDay) {
  if (!((1 <= weekDay) && (weekDay <= 7))) {
    throw InvalidWeekDayException();
  }

  final now = DateTime.now();
  if (now.weekday == weekDay) {
    return 'Today';
  } else {
    final week = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return week[weekDay - 1];
  }
}

class InvalidWeekDayException implements Exception {}
