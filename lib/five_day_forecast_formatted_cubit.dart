import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/day_forecast.dart';
import 'package:test_flutter_task_innowise/five_day_forecast_cubit.dart';
import 'package:weather/weather.dart';

import 'timed_weather.dart';

class FiveDayForeCastFormattedCubit extends Cubit<List<DayForecast>> {
  FiveDayForeCastFormattedCubit() : super(List<DayForecast>.empty()) {
    FiveDayForecastCubit().stream.listen(_forecastListener);
  }

  Future<void> _forecastListener(List<Weather> forecast) async {
    if (forecast.isEmpty) return;

    final formattedForecast = _getFormattedForecast(forecast);
    emit(formattedForecast);
  }

  List<DayForecast> _getFormattedForecast(List<Weather> forecast) {
    List<DayForecast> fiveDayForecast = [];

    List<TimedWeather> timedWeathers = [];
    const unsetValue = 0;
    var currentDay = unsetValue;
    for (final weather in forecast) {
      final date = weather.date!;
      final nextDay = date.day;
      if (currentDay < nextDay) {
        if (currentDay != unsetValue) {
          final dayName = _getDayName(date);
          final dayForeCast = DayForecast(dayName, timedWeathers);
          fiveDayForecast.add(dayForeCast);

          timedWeathers.clear();
        }
        currentDay = nextDay;
      }
      final time = '${date.hour}:${date.minute}';
      final timedTemperature = TimedWeather(time, weather);
      timedWeathers.add(timedTemperature);
    }
    final date = forecast.last.date!;
    final dayName = _getDayName(date);
    final dayForeCast = DayForecast(dayName, timedWeathers);
    fiveDayForecast.add(dayForeCast);

    return fiveDayForecast;
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    if (now.day == date.day) {
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
      return week[date.weekday - 1];
    }
  }
}
