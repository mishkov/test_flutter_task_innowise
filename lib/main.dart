import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/main_page_title_cubit.dart';

import 'day_forecast.dart';
import 'day_forecast_view.dart';
import 'detail_weather_page.dart';
import 'five_day_forecast_formatted_cubit.dart';

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
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocProvider(
          create: (_) => MainPageTitleCubit(),
          child: BlocBuilder<MainPageTitleCubit, String>(
            builder: (_, title) {
              return Text(title);
            },
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => FiveDayForecastFormattedCubit(),
        child: BlocBuilder<FiveDayForecastFormattedCubit, List<DayForecast>>(
          builder: (_, fiveDayForecast) {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: fiveDayForecast.length,
              itemBuilder: (_, index) {
                return DayForecastView(fiveDayForecast[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final forecast = FiveDayForecastFormattedCubit();
          final dayForecast = FiveDayForecastFormattedCubit().state.first;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return DetailWeatherPage(dayForecast);
            }),
          );
        },
        child: Text('Current Weather'),
      ),
    );
  }
}
