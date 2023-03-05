import 'package:flutter/material.dart';
import 'package:flutter_weather/weather.dart';
import 'package:intl/intl.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather currentWeather =
      Weather(temp: 15, description: '晴れ', tempMax: 18, tempMin: 14);
  List<Weather> hourlyWeather = [
    Weather(
        temp: 20,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 10),
        rainyPercent: 0),
    Weather(
        temp: 18,
        description: '雨',
        time: DateTime(2021, 10, 1, 11),
        rainyPercent: 90),
    Weather(
        temp: 17,
        description: '曇り',
        time: DateTime(2021, 10, 1, 12),
        rainyPercent: 10),
    Weather(
        temp: 19,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 13),
        rainyPercent: 0),
    Weather(
        temp: 20,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 10),
        rainyPercent: 0),
    Weather(
        temp: 18,
        description: '雨',
        time: DateTime(2021, 10, 1, 11),
        rainyPercent: 90),
    Weather(
        temp: 17,
        description: '曇り',
        time: DateTime(2021, 10, 1, 12),
        rainyPercent: 10),
    Weather(
        temp: 19,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 13),
        rainyPercent: 0),
    Weather(
        temp: 20,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 10),
        rainyPercent: 0),
    Weather(
        temp: 18,
        description: '雨',
        time: DateTime(2021, 10, 1, 11),
        rainyPercent: 90),
    Weather(
        temp: 17,
        description: '曇り',
        time: DateTime(2021, 10, 1, 12),
        rainyPercent: 10),
    Weather(
        temp: 19,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 13),
        rainyPercent: 0),
    Weather(
        temp: 20,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 10),
        rainyPercent: 0),
    Weather(
        temp: 18,
        description: '雨',
        time: DateTime(2021, 10, 1, 11),
        rainyPercent: 90),
    Weather(
        temp: 17,
        description: '曇り',
        time: DateTime(2021, 10, 1, 12),
        rainyPercent: 10),
    Weather(
        temp: 19,
        description: '晴れ',
        time: DateTime(2021, 10, 1, 13),
        rainyPercent: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text("大阪市", style: TextStyle(fontSize: 25)),
            Text(currentWeather.description!),
            Text('${currentWeather.temp!} ℃', style: TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('最高:${currentWeather.tempMax}℃'),
                ),
                Text('最低:${currentWeather.tempMin}℃'),
              ],
            ),
            SizedBox(height: 50),
            Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: hourlyWeather.map((weather) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      children: [
                        Text('${DateFormat('H').format(weather.time!)}時'),
                        Text(
                          '${weather.rainyPercent}%',
                          style: TextStyle(color: Colors.lightBlueAccent),
                        ),
                        Icon(Icons.wb_sunny_sharp),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('${weather.temp}℃',
                              style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
// children: [
// Column(children: [
// Text('${DateFormat('H').format(hourlyWeather[0].time!)}時'),
// Text('${hourlyWeather[0].rainyPercent}%'),
// Icon(Icons.wb_sunny_sharp),
// Text('${hourlyWeather[0].temp}')
// ]),
// ],
