import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';

import 'main_page/main_page.dart';
import 'detail_weather/detail_weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == MainPage.routeName) {
          return MaterialPageRoute(builder: (_) => MainPage());
        }

        if (settings.name == '/weather-details') {
          return MaterialPageRoute(builder: (_) {
            final today = settings.arguments as DayForecast;
            return DetailWeatherPage(today);
          });
        }

        return MaterialPageRoute(builder: (context) => MainPage());
      },
    );
  }
}
