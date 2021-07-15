import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';

import 'day_forecast.dart';
import 'location_checked.dart';
import 'timed_temperature.dart';

class FiveDayForecastCubit extends Cubit<List<DayForecast>> {
  static final _fiveDayForecastCubit = FiveDayForecastCubit._internal();

  factory FiveDayForecastCubit() => _fiveDayForecastCubit;

  FiveDayForecastCubit._internal() : super(List<DayForecast>.empty()) {
    _getFiveDayForecast().then((fiveDayForecast) => emit(fiveDayForecast));
  }

  Future<List<DayForecast>> _getFiveDayForecast() async {
    final String _apiKey = '18b9ecf9d78ff455db52c01518efa59e';
    final weather = WeatherFactory(_apiKey);
    final location = await LocationChecked().getLocation();
    final fiveDayForecastAsWeather = await weather.fiveDayForecastByLocation(
      location.latitude!,
      location.longitude!,
    );

    return _weatherToDayForecast(fiveDayForecastAsWeather);
  }

  List<DayForecast> _weatherToDayForecast(List<Weather> weathers) {
    List<DayForecast> fiveDayForecast = [];

    List<TimedTemperature> timedTemperatures = [];
    const unsetValue = 0;
    var currentDay = unsetValue;
    for (final weather in weathers) {
      final date = weather.date!;
      final nextDay = date.day;
      if (currentDay < nextDay) {
        if (currentDay != unsetValue) {
          final dayName = _getDayName(date);
          final dayForeCast = DayForecast(dayName, timedTemperatures);
          fiveDayForecast.add(dayForeCast);

          timedTemperatures.clear();
        }
        currentDay = nextDay;
      }
      final time = '${date.hour}:${date.minute}';
      final temperature = weather.temperature!;
      final timedTemperature = TimedTemperature(time, temperature);
      timedTemperatures.add(timedTemperature);
    }
    final date = weathers.last.date!;
    final dayName = _getDayName(date);
    final dayForeCast = DayForecast(dayName, timedTemperatures);
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
      return week[date.weekday];
    }
  }
}
