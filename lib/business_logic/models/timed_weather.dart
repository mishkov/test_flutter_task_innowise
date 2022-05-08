import 'package:weather/weather.dart';

extension _timeExtractor on Weather {
  String get hoursAndMinutes {
    final time = date != null ? '${date!.hour}:${date!.minute}' : '';

    return time;
  }
}

class TimedWeather {
  String time;
  Weather weather;

  TimedWeather(this.time, this.weather);

  TimedWeather.fromWeather(this.weather) : time = weather.hoursAndMinutes;
}
