import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_logic/cubits/five_day_forecast_formatted_cubit.dart';
import '../business_logic/states/cubit_state.dart';
import '../business_logic/states/five_day_forecast_formatted_state.dart';
import 'day_forecast_view.dart';
import '../ui/detail_weather_page.dart';
import 'app_bar/application_bar.dart';
import 'loading_view.dart';
import 'try_again_button.dart';

class MainPage extends StatelessWidget {
  static final routeName = '/';

  @override
  Widget build(BuildContext mainPageContext) {
    final fiveDayForecastFormattedCubit = FiveDayForecastFormattedCubit();

    return Scaffold(
      appBar: MainPageAppBar(),
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
