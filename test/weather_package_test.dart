import 'package:flutter_test/flutter_test.dart';
import 'package:weather/weather.dart';

void main() {
  test(
    'tests number of timed weathers returned by fiveDayForecastByLocation()',
    () async {
      final apiKey = '18b9ecf9d78ff455db52c01518efa59e';
      final weather = WeatherFactory(apiKey);

      // Minsk city, Belarus
      final latitude = 53.9006;
      final longitude = 27.5590;
      final forecast =
          await weather.fiveDayForecastByLocation(latitude, longitude);

      const numberOfDays = 5;
      const hoursInDay = 24;
      const weatherHoursDelta = 3;
      const timesPerDay = hoursInDay / weatherHoursDelta;
      const numberOfTimedWeather = numberOfDays * timesPerDay;

      expect(forecast.length, numberOfTimedWeather);
    },
  );
}
