import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/business_logic/states/main_page_title_state.dart';

import '../states/cubit_state.dart';
import 'five_day_forecast_cubit.dart';
import '../states/five_day_forecast_state.dart';

class MainPageTitleCubit extends Cubit<MainPageTitleState> {
  MainPageTitleCubit()
      : super(MainPageTitleState()
          ..status = Status.loading
          ..data = 'Loading') {
    var forecast = FiveDayForecastCubit();
    forecast.stream.listen(_forecastListener);
  }

  Future<void> _forecastListener(FiveDayForecastState forecastState) async {
    final titleState = MainPageTitleState()
      ..status = forecastState.status
      ..errorDetail = forecastState.errorDetail;
    if (forecastState.status == Status.done) {
      titleState.data = forecastState.data.first.areaName!;
    } else if (forecastState.status == Status.loading) {
      titleState.data = 'Loading';
    } else if (forecastState.status == Status.failed) {
      titleState.data = 'Error';
    } else {
      titleState.data = 'Uknown';
    }
    emit(titleState);
  }
}
