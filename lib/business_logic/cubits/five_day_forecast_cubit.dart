import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/business_logic/states/cubit_state.dart';
import 'package:weather/weather.dart';

import '../states/five_day_forecast_state.dart';
import '../location_checked.dart';

class FiveDayForecastCubit extends Cubit<FiveDayForecastState> {
  static final _fiveDayForecastCubit = FiveDayForecastCubit._internal();
  final _loadingState = FiveDayForecastState()..status = Status.loading;

  factory FiveDayForecastCubit() => _fiveDayForecastCubit;

  FiveDayForecastCubit._internal()
      : super(FiveDayForecastState()..status = Status.loading) {
    emitFiveDayForecast();
  }

  Future<void> emitFiveDayForecast() async {
    emit(_loadingState);
    final String _apiKey = '18b9ecf9d78ff455db52c01518efa59e';
    final weather = WeatherFactory(_apiKey);
    final state = FiveDayForecastState();
    var location;
    try {
      location = await LocationChecked().getLocation();
    } catch (error) {
      state.status = Status.failed;
      state.errorDetail = 'Failed getting location';
      print('$error ${StackTrace.current}');
      emit(state);
      return Future.error(error, StackTrace.current);
    }
    var fiveDayForecast;
    try {
      fiveDayForecast = await weather
          .fiveDayForecastByLocation(
            location.latitude!,
            location.longitude!,
          )
          .timeout(Duration(seconds: 20));
      state.data = fiveDayForecast;
    } on TimeoutException catch (error) {
      state.status = Status.failed;
      state.errorDetail = 'Timeout of internet connection.';
      print('$error ${StackTrace.current}');
      emit(state);
      return Future.error(error, StackTrace.current);
    } catch (error) {
      state.status = Status.failed;
      state.errorDetail = 'Failed getting five day forecast by location.';
      print('$error ${StackTrace.current}');
      emit(state);
      return Future.error(error, StackTrace.current);
    }

    state.status = Status.done;
    emit(state);
  }
}
