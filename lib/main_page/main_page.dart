import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'day_forecast_view.dart';
import '../detail_weather/detail_weather_page.dart';
import 'loading_view.dart';
import 'main_page_cubit.dart';
import 'try_again_button.dart';

class MainPage extends StatelessWidget {
  static final routeName = '/';

  @override
  Widget build(BuildContext mainPageContext) {
    final mainPageCubit = MainPageCubit();

    return BlocProvider.value(
      value: mainPageCubit,
      child: BlocBuilder<MainPageCubit, MainPageState>(
          builder: (forecastContext, state) {
        String title = '';
        if (state.forecastStatus == ForecastAvailabilityStatus.loading) {
          title = 'Loading';
        } else if (state.forecastStatus == ForecastAvailabilityStatus.done) {
          if (state.forecast!.isNotEmpty) {
            title = state.forecast!.first.weathers.first.weather.areaName ??
                'Weather';
          } else {
            title = 'No Weather';
          }
        } else if (state.forecastStatus == ForecastAvailabilityStatus.error) {
          title = 'Failed';
        }

        Widget content;
        if (state.forecastStatus == ForecastAvailabilityStatus.done) {
          content = ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: state.forecast!.length,
            itemBuilder: (_, index) {
              return DayForecastView(state.forecast![index]);
            },
          );
        } else if (state.forecastStatus == ForecastAvailabilityStatus.loading) {
          content = const LoadingView();
        } else if (state.forecastStatus == ForecastAvailabilityStatus.error) {
          content = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(state.errorDetail),
              const TryAgainButton(),
            ],
          );
        } else {
          content = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Unknown response status.'),
            ],
          );
        }

        Widget elevatedButton;
        if (state.forecastStatus == ForecastAvailabilityStatus.done) {
          elevatedButton = ElevatedButton(
            onPressed: () {
              final dayForecast = state.forecast!.firstWhere((dayForecast) {
                return dayForecast.weekDay == DateTime.now().weekday;
              });

              Navigator.pushNamed(
                mainPageContext,
                DetailWeatherPage.routeName,
                arguments: dayForecast,
              );
            },
            child: Text('Current Weather'),
          );
        } else if (state.forecastStatus == ForecastAvailabilityStatus.loading) {
          elevatedButton = ElevatedButton(
            onPressed: null,
            child: Text('Loading...'),
          );
        } else if (state.forecastStatus == ForecastAvailabilityStatus.error) {
          elevatedButton = ElevatedButton(
            onPressed: null,
            child: Text('Failed'),
          );
        } else {
          elevatedButton = ElevatedButton(
            onPressed: null,
            child: Text('Unknown response status!'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: content,
          ),
          floatingActionButton: elevatedButton,
        );
      }),
    );
  }
}
