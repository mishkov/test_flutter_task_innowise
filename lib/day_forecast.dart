import 'package:test_flutter_task_innowise/timed_weather.dart';

class DayForecast {
  final String dayName;
  final List<TimedWeather> temperatures;

  DayForecast(this.dayName, this.temperatures);
}
