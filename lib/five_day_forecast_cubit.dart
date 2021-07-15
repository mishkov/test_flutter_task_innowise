import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';

import 'location_checked.dart';

class FiveDayForecastCubit extends Cubit<List<Weather>> {
  static final _fiveDayForecastCubit = FiveDayForecastCubit._internal();

  factory FiveDayForecastCubit() => _fiveDayForecastCubit;

  FiveDayForecastCubit._internal() : super(List<Weather>.empty()) {
    _getFiveDayForecast().then((fiveDayForecast) => emit(fiveDayForecast));
  }

  Future<List<Weather>> _getFiveDayForecast() async {
    final String _apiKey = '18b9ecf9d78ff455db52c01518efa59e';
    final weather = WeatherFactory(_apiKey);
    final location = await LocationChecked().getLocation();
    final fiveDayForecastAsWeather = await weather.fiveDayForecastByLocation(
      location.latitude!,
      location.longitude!,
    );

    return fiveDayForecastAsWeather;
  }
}
