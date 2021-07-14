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
            return Container();
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
}

class NoLocationException implements Exception {
  String cause;

  NoLocationException(this.cause);
}
