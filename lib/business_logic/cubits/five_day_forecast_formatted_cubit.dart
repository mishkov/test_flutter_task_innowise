import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/business_logic/models/day_forecast.dart';
import 'package:test_flutter_task_innowise/business_logic/cubits/five_day_forecast_cubit.dart';
import 'package:test_flutter_task_innowise/business_logic/states/five_day_forecast_formatted_state.dart';
import 'package:weather/weather.dart';

import '../states/cubit_state.dart';
import '../states/five_day_forecast_state.dart';
import '../models/timed_weather.dart';

class FiveDayForecastFormattedCubit
    extends Cubit<FiveDayForecstFormattedState> {
  static FiveDayForecastFormattedCubit _instance =
      FiveDayForecastFormattedCubit._internal();

  factory FiveDayForecastFormattedCubit() => _instance;

  FiveDayForecastFormattedCubit._internal()
      : super(FiveDayForecstFormattedState()..status = Status.loading) {
    FiveDayForecastCubit().stream.listen(_forecastListener);
  }

  void tryAgain() {
    FiveDayForecastCubit().emitFiveDayForecast();
  }

  Future<void> _forecastListener(FiveDayForecastState forecastState) async {
    final formattedForecastState = FiveDayForecstFormattedState()
      ..status = forecastState.status
      ..errorDetail = forecastState.errorDetail;
    if (forecastState.status == Status.done) {
      formattedForecastState.data = _getFormattedForecast(forecastState.data);
    }
    emit(formattedForecastState);
  }

  List<DayForecast> _getFormattedForecast(List<Weather> forecast) {
    var days = [];
    forecast.forEach((weather) {
      final day = weather.date!.day;
      if (!days.contains(day)) {
        days.add(day);
      }
    });

    List<DayForecast> fiveDayForecast = [];
    days.forEach((day) {
      final daysWeather = forecast.where((weather) {
        return weather.date!.day == day;
      });
      var timedWeathers = daysWeather.map((dayWeather) {
        final date = dayWeather.date!;
        final time = '${date.hour}:${date.minute}';
        return TimedWeather(time, dayWeather);
      });

      final dayForecast = DayForecast(daysWeather.first.date!.weekday, timedWeathers.toList());
      fiveDayForecast.add(dayForecast);
    });

    return fiveDayForecast;
  }
}
