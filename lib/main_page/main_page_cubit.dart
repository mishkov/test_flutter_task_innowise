import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/five_day_forecast.dart';
import 'package:test_flutter_task_innowise/location/coordinate_provider.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageState.initial()) {
    fetchForecast();
  }

  // TODO: Review this method
  Future<void> fetchForecast() async {
    emit(MainPageState(forecastStatus: ForecastAvailabilityStatus.loading));

    final coordinateProvider = CoordinateProvider.instance;
    final fiveDayForecast = FiveDayForecast.instance;

    coordinateProvider.fetch();

    coordinateProvider.stream.listen((coordinate) {
      if (fiveDayForecast.last == null) {
        fiveDayForecast.latitude = coordinate.latitude;
        fiveDayForecast.longitude = coordinate.longitude;
        fiveDayForecast.fetch();

        fiveDayForecast.stream.listen((forecast) {
          emit(MainPageState(
            forecast: forecast,
            forecastStatus: ForecastAvailabilityStatus.done,
          ));
        });
      } else {
        emit(MainPageState(
          forecast: fiveDayForecast.last,
          forecastStatus: ForecastAvailabilityStatus.done,
        ));
      }
    }, onError: (error, stackTrace) {
      if (error is LocationGettingTimeoutException) {
        emit(MainPageState(
          forecastStatus: ForecastAvailabilityStatus.error,
          errorDetail: 'Getting location is timeout',
        ));
      } else {
        emit(MainPageState(
          forecastStatus: ForecastAvailabilityStatus.error,
          errorDetail: 'Unknow Error occured',
        ));
      }
    });
  }
}

class MainPageState {
  final List<DayForecast>? forecast;
  final ForecastAvailabilityStatus forecastStatus;
  final String errorDetail;

  MainPageState(
      {this.forecast,
      required this.forecastStatus,
      this.errorDetail = 'No error occured'});

  MainPageState.initial()
      : forecast = null,
        forecastStatus = ForecastAvailabilityStatus.loading,
        errorDetail = 'No error occured';
}

enum ForecastAvailabilityStatus { loading, done, error, unknown }
