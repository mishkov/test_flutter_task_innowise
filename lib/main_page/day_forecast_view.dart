import 'package:flutter/material.dart';
import 'package:test_flutter_task_innowise/five_day_forecast/day_forecast.dart';

import '../get_week_day_name.dart';
import '../detail_weather/detail_weather_page.dart';

class DayForecastView extends StatelessWidget {
  final DayForecast dayForecast;

  DayForecastView(this.dayForecast);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            getDayName(dayForecast.weekDay),
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Divider(height: 5),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: dayForecast.weathers.length,
          itemBuilder: (_, int index) {
            final weather = dayForecast.weathers[index];
            final icon = weather.weather.weatherIcon;
            final iconUrl = 'http://openweathermap.org/img/w/$icon.png';
            final temp = weather.weather.temperature!.celsius!.round();
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: SizedBox(
                    child: Image.network(
                      iconUrl,
                      scale: 0.2,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return CircularProgressIndicator.adaptive();
                      },
                      errorBuilder: (_, error, stackTrace) {
                        print(
                            'When image loading in DayForecastView: $error $stackTrace');
                        return Icon(Icons.signal_wifi_connected_no_internet_4);
                      },
                    ),
                  ),
                  title: Text(
                    weather.time,
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  subtitle: Text(
                    weather.weather.weatherMain!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Text(
                    '$temp??',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailWeatherPage.routeName,
                      arguments: dayForecast,
                    );
                  },
                ),
                !(index == dayForecast.weathers.length - 1)
                    ? Divider(
                        height: 2,
                        indent: 80,
                      )
                    : SizedBox.shrink()
              ],
            );
          },
        ),
      ],
    );
  }
}
