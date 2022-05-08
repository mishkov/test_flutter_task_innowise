import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/business_logic/cubits/main_page_title_cubit.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';

import 'business_logic/states/cubit_state.dart';
import 'main_page/app_bar/application_bar.dart';
import 'main_page/main_page.dart';
import 'ui/day_forecast_view.dart';
import 'ui/detail_weather_page.dart';
import 'business_logic/cubits/five_day_forecast_formatted_cubit.dart';
import 'business_logic/states/five_day_forecast_formatted_state.dart';
import 'business_logic/states/main_page_title_state.dart';

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
          return MaterialPageRoute(builder: (_) {
            return MainPage();
          });
        }

        if (settings.name == '/weather-details') {
          return MaterialPageRoute(builder: (_) {
            return DetailWeatherPage(settings.arguments as DayForecast);
          });
        }

        return MaterialPageRoute(builder: (context) => MainPage());
      },
    );
  }
}
