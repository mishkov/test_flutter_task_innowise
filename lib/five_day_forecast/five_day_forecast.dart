import 'dart:async';

import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/timed_weather.dart';
import 'package:weather/weather.dart';

class FiveDayForecast {
  static final _weatherApiKey = '18b9ecf9d78ff455db52c01518efa59e';
  final _weather = WeatherFactory(_weatherApiKey);
  final _forecastStreamController =
      StreamController<List<DayForecast>>.broadcast();
  double _latitude = 0.0;
  double _longitude = 0.0;
  List<DayForecast> _last = [];

  static final instance = FiveDayForecast._internal();

  factory FiveDayForecast() => instance;

  FiveDayForecast._internal();

  Stream<List<DayForecast>> get stream => _forecastStreamController.stream;

  List<DayForecast> get last => _last;

  set latitude(double latitude) => _latitude = latitude;

  set longitude(double longitude) => _longitude = longitude;

  Future<void> fetch() async {
    const timeoutTime = Duration(seconds: 20);

    final timedWeathers = await _weather
        .fiveDayForecastByLocation(_latitude, _longitude)
        .timeout(timeoutTime, onTimeout: () {
      throw WeatherTimeoutException();
    });

    _last = timedWeathers.splitByWeekDay();
    _forecastStreamController.add(_last);
  }

  Future<void> dispose() async {
    _forecastStreamController.close();
  }
}

extension _ToTimedWeatherConverter on List<Weather> {
  List<TimedWeather> toTimedWeather() {
    return map(TimedWeather.fromWeather).toList();
  }
}

extension _WeekDayCheker on Weather {
  bool isOf(int weekDay) {
    return date?.weekday == weekDay;
  }
}

extension _ByDaySplitter on List<Weather> {
  List<Weather> of(int weekDay) {
    return where((weather) => weather.isOf(weekDay)).toList();
  }

  List<DayForecast> splitByWeekDay() {
    List<DayForecast> result = [];

    for (var weekDay = DateTime.monday; weekDay <= DateTime.sunday; weekDay++) {
      final weekDayForecast = this.of(weekDay);

      final timedForecast = weekDayForecast.toTimedWeather();
      DayForecast(weekDay, timedForecast);
    }

    return result;
  }
}

class WeatherTimeoutException implements Exception {
  WeatherTimeoutException();
}
