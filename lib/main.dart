import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/business_logic/cubits/main_page_title_cubit.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';

import 'business_logic/states/cubit_state.dart';
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

class MainPage extends StatelessWidget {
  static final routeName = '/';

  @override
  Widget build(BuildContext mainPageContext) {
    final mainPageTitleCubit = MainPageTitleCubit();
    final fiveDayForecastFormattedCubit = FiveDayForecastFormattedCubit();

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<MainPageTitleCubit, MainPageTitleState>(
          bloc: mainPageTitleCubit,
          builder: (_, state) => Text(state.data),
        ),
      ),
      body: Center(
        child: BlocProvider.value(
          value: fiveDayForecastFormattedCubit,
          child: BlocBuilder<FiveDayForecastFormattedCubit,
              FiveDayForecstFormattedState>(
            bloc: fiveDayForecastFormattedCubit,
            builder: (forecastContext, state) {
              if (state.status == Status.done) {
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: state.data.length,
                  itemBuilder: (_, index) {
                    return DayForecastView(state.data[index]);
                  },
                );
              } else if (state.status == Status.loading) {
                return const LoadingView();
              } else if (state.status == Status.failed) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errorDetail),
                    const TryAgainButton(),
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Unknown response status.'),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<FiveDayForecastFormattedCubit,
          FiveDayForecstFormattedState>(
        bloc: fiveDayForecastFormattedCubit,
        builder: (_, state) {
          if (state.status == Status.done) {
            return ElevatedButton(
              onPressed: () {
                final dayForecast = state.data.first;
                Navigator.pushNamed(
                  mainPageContext,
                  DetailWeatherPage.routeName,
                  arguments: dayForecast,
                );
              },
              child: Text('Current Weather'),
            );
          } else if (state.status == Status.loading) {
            return ElevatedButton(
              onPressed: null,
              child: Text('Loading...'),
            );
          } else if (state.status == Status.failed) {
            return ElevatedButton(
              onPressed: null,
              child: Text('Failed'),
            );
          } else {
            return ElevatedButton(
              onPressed: null,
              child: Text('Unknown response status!'),
            );
          }
        },
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: CircularProgressIndicator.adaptive(),
        ),
        Text(
          'Loading...',
        ),
      ],
    );
  }
}

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<FiveDayForecastFormattedCubit>().tryAgain();
      },
      child: Text('Try again'),
    );
  }
}
