import 'package:test_flutter_task_innowise/business_logic/models/timed_weather.dart';

class DayForecast {
  final String dayName;
  final List<TimedWeather> weathers;

  DayForecast(this.dayName, this.weathers);
}
