import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

import 'day_weather.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _title = 'Loading';
  final String _apiKey = '18b9ecf9d78ff455db52c01518efa59e';
  final _week = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder<List<Weather>>(
        future: _getfiveDayForecast(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(itemBuilder: (listBuildContext, index) {
              var dayName;
              final date = snapshot.data![index].date!;
              final weekday = date.weekday;
              if (weekday == 1) {
                dayName = 'Today';
              } else {
                dayName = _week[weekday];
              }
              return DayWeather(
                dayName,
                _getDayTemperatures(snapshot.data!, day: date.day),
              );
            });
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error != null) {
              return Center(
                child: Text(error.toString()),
              );
            } else {
              return Center(
                child: Text('Unknown Error!'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }

  Future<List<Weather>> _getfiveDayForecast() async {
    final weather = WeatherFactory(_apiKey);
    final location = await _getLocation();
    final fivedayForecast = await weather.fiveDayForecastByLocation(
      location.latitude!,
      location.longitude!,
    );

    return fivedayForecast;
  }

  Future<LocationData> _getLocation() async {
    var location = Location();
    await _checkService(location);
    await _checkPermission(location);

    var locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      throw NoLocationException('latitude or longtitude is null!');
    }

    return locationData;
  }

  Future<void> _checkService(Location location) async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
  }

  Future<void> _checkPermission(Location location) async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
  }

  Map<String, Temperature> _getDayTemperatures(List<Weather> weathers,
      {required int day}) {
    var temperatures = Map<String, Temperature>();
    for (var weather in weathers) {
      if (weather.date!.day == day) {
        final time = '${weather.date!.hour}:${weather.date!.minute}';
        temperatures[time] = weather.temperature!;
      } else {
        break;
      }
    }

    return temperatures;
  }
}

class NoLocationException implements Exception {
  String cause;

  NoLocationException(this.cause);
}
