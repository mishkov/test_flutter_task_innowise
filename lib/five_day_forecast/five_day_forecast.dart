import 'package:test_flutter_task_innowise/business_logic/models/day_forecast.dart';
import 'package:test_flutter_task_innowise/business_logic/models/timed_weather.dart';
import 'package:weather/weather.dart';

class FiveDayForecast {
  static final _weatherApiKey = '18b9ecf9d78ff455db52c01518efa59e';
  final _weather = WeatherFactory(_weatherApiKey);

  Future<List<DayForecast>> forLocation(
    double latitude,
    double longitude,
  ) async {
    const timeoutTime = Duration(seconds: 20);

    final timedWeathers = await _weather
        .fiveDayForecastByLocation(latitude, longitude)
        .timeout(timeoutTime, onTimeout: () {
      throw WeatherTimeoutException();
    });

    return timedWeathers.splitByWeekDay();
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
