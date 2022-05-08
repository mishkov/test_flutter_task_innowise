import 'package:test_flutter_task_innowise/five_day_forecast/timed_weather.dart';

class DayForecast {
  final int weekDay;
  final List<TimedWeather> weathers;

  DayForecast(this.weekDay, this.weathers);
}
