import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_task_innowise/day_forecast.dart';
import 'package:weather_icons/weather_icons.dart';

class DetailWeatherPage extends StatelessWidget {
  final DayForecast dayForecast;

  DetailWeatherPage(this.dayForecast);

  @override
  Widget build(BuildContext context) {
    final weather = dayForecast.weathers.first.weather;
    final icon = weather.weatherIcon;
    final iconUrl = 'http://openweathermap.org/img/w/$icon.png';
    final temp = weather.temperature!.celsius!.round();

    const iconSize = 50.0;
    const iconSpace = 20.0;
    const iconColor = Colors.amber;
    const iconTextStyle = TextStyle(
      color: iconColor,
      fontSize: 20,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(dayForecast.dayName),
      ),
      body: Column(
        children: [
          Image.network(
            iconUrl,
            scale: 0.2,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Text(
            '${weather.areaName}, ${weather.country}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            '$temp°C | ${weather.weatherMain}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
            ),
          ),
          Divider(
            height: 50,
            indent: 100,
            endIndent: 100,
            thickness: 2,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  weather.humidity != null
                      ? Column(
                          children: [
                            Icon(
                              WeatherIcons.humidity,
                              size: iconSize,
                              color: iconColor,
                            ),
                            Container(
                              height: iconSpace,
                            ),
                            Text(
                              '${weather.humidity!.round()}%',
                              style: iconTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  weather.rainLastHour != null
                      ? Column(
                          children: [
                            Icon(
                              WeatherIcons.raindrops,
                              size: iconSize,
                              color: iconColor,
                            ),
                            Container(
                              height: iconSpace,
                            ),
                            Text(
                              '${weather.rainLastHour!.toStringAsFixed(1)} mm',
                              style: iconTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  weather.pressure != null
                      ? Column(
                          children: [
                            Icon(
                              WeatherIcons.barometer,
                              color: iconColor,
                              size: iconSize,
                            ),
                            Container(
                              height: iconSpace,
                            ),
                            Text(
                              '${weather.pressure} Pa',
                              style: iconTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  weather.windSpeed != null
                      ? Column(
                          children: [
                            Icon(
                              WeatherIcons.strong_wind,
                              size: iconSize,
                              color: iconColor,
                            ),
                            Container(
                              height: iconSpace,
                            ),
                            Text(
                              '${weather.windSpeed} m/s',
                              style: iconTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                  weather.windDegree != null
                      ? Column(
                          children: [
                            WindIcon(
                              degree: weather.windDegree!,
                              size: iconSize,
                              color: iconColor,
                            ),
                            Text(
                              '${weather.windDegree} °',
                              style: iconTextStyle,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ],
          ),
          Divider(
            height: 50,
            indent: 100,
            endIndent: 100,
            thickness: 2,
          ),
          TextButton(
            onPressed: _copyWeatherToCliBoard,
            child: Text(
              'Share',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copyWeatherToCliBoard() {
    final weather = dayForecast.weathers.first.weather;
    final temp = weather.temperature!.celsius!.round();
    final weatherAsText = '''
    ${weather.areaName}, ${weather.country}\n
    ${weather.date}\n
    $temp°C | ${weather.weatherMain}\n
    Humidity: ${weather.humidity!.round()}%;\n
    Rain last 3 hours: ${(weather.rainLast3Hours ?? -1.0).toStringAsFixed(1)} mm;\n
    Preassure: ${weather.pressure} Pa;\n
    Wind speed: ${weather.windSpeed} m/s;\n
    Wind degree: ${weather.windDegree} °;\n
    ''';
    Clipboard.setData(ClipboardData(text: weatherAsText));
  }
}
