import 'package:test_flutter_task_innowise/timed_temperature.dart';

class DayForecast {
  final String dayName;
  final List<TimedTemperature> temperatures;

  DayForecast(this.dayName, this.temperatures);
}
