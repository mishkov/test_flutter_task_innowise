import 'package:test_flutter_task_innowise/business_logic/models/timed_weather.dart';

class DayForecast {
  final int weekDay;
  final List<TimedWeather> weathers;

  DayForecast(this.weekDay, this.weathers);
}
