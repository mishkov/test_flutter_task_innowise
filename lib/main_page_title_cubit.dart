import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';

import 'five_day_forecast_cubit.dart';

class MainPageTitleCubit extends Cubit<String> {
  MainPageTitleCubit() : super('Loading...') {
    var forecast = FiveDayForecastCubit();
    forecast.stream.listen(_forecastListener);
  }

  Future<void> _forecastListener(List<Weather> forecast) async {
    if (forecast.isEmpty) return;
    emit(forecast.first.areaName!);
  }
}
