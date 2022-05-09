import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';
import 'package:weather_icons/weather_icons.dart';

import '../get_week_day_name.dart';

class DetailWeatherPage extends StatelessWidget {
  static final routeName = '/weather-details';

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
        title: Text(
          '${getDayName(dayForecast.weekDay)} – ${weather.date!.hour}:${weather.date!.minute}',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              iconUrl,
              scale: 0.5,
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (_, error, stackTrace) {
                print('$error $stackTrace');
                return Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Icon(
                    Icons.signal_wifi_connected_no_internet_4,
                    color: Colors.grey[600],
                    size: 60,
                  ),
                );
              },
            ),
            Text(
              '${weather.areaName}, ${weather.country}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            Text(
              '$temp°C | ${weather.weatherMain}',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
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
                              SizedBox(
                                height: iconSpace,
                              ),
                              Text(
                                '${weather.humidity!.round()}%',
                                style: iconTextStyle,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    weather.rainLastHour != null
                        ? Column(
                            children: [
                              Icon(
                                WeatherIcons.raindrops,
                                size: iconSize,
                                color: iconColor,
                              ),
                              SizedBox(
                                height: iconSpace,
                              ),
                              Text(
                                '${weather.rainLastHour!.toStringAsFixed(1)} mm',
                                style: iconTextStyle,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    weather.pressure != null
                        ? Column(
                            children: [
                              Icon(
                                WeatherIcons.barometer,
                                color: iconColor,
                                size: iconSize,
                              ),
                              SizedBox(
                                height: iconSpace,
                              ),
                              Text(
                                '${weather.pressure} Pa',
                                style: iconTextStyle,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
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
                              SizedBox(
                                height: iconSpace,
                              ),
                              Text(
                                '${weather.windSpeed} m/s',
                                style: iconTextStyle,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
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
                        : SizedBox.shrink(),
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
