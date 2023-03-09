import 'package:flutter/material.dart';
import 'package:flutter_weather/weather.dart';
import 'package:flutter_weather/zip_code.dart';
import 'package:intl/intl.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  Weather? currentWeather;
  String address = "－";
  String errorMessage = "";
  List<Weather> hourlyWeather = [];
  List<Weather> dailyWeather = [];

  List<String> weekDay = ["月", "火", "水", "木", "金", "土", "日"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: 200,
              child: TextField(
                onSubmitted: (value) async {
                  //郵便番号から住所を検索
                  print(value);
                  Map<String, String> response = {};
                  response = (await ZipCode.searchAddressFromZipCode(value))!;
                  if (response.containsKey("message")) {
                    errorMessage = response["message"]!;
                  } else {
                    errorMessage = "";
                  }
                  if (response.containsKey("address")) {
                    address = response["address"]!;
                    var result = await Weather.getCurrentWeather(value);
                    if (result != null) {
                      currentWeather = result;
                      print(currentWeather);
                      Map<String, List<Weather>>? weatherForecast =
                          await Weather.getForecast(
                              lat: currentWeather!.lat!,
                              lon: currentWeather!.lon!);
                      if (weatherForecast != null) {
                        hourlyWeather = weatherForecast["hourly"]!;
                        dailyWeather = weatherForecast["daily"]!;
                      }
                    }
                  }
                  print(address);
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "郵便番号を入力"),
              ),
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 50),
            Text(address, style: TextStyle(fontSize: 25)),
            Text(currentWeather != null
                ? currentWeather!.description != null
                    ? currentWeather!.description!
                    : "-"
                : "-"),
            Text(
                '${currentWeather != null ? currentWeather!.temp != null ? currentWeather!.temp! : "-" : "-"} ℃',
                style: TextStyle(fontSize: 80)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                      '最高:${currentWeather != null ? currentWeather!.tempMax != null ? currentWeather!.tempMax! : "-" : "-"}℃'),
                ),
                Text(
                    '最低:${currentWeather != null ? currentWeather!.tempMin != null ? currentWeather!.tempMin! : "-" : "-"}℃'),
              ],
            ),
            SizedBox(height: 50),
            Divider(height: 0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: hourlyWeather == []
                  ? Container()
                  : Row(
                      children: hourlyWeather.map((weather) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            children: [
                              Text('${DateFormat('H').format(weather.time!)}時'),
                              // Text(
                              //   '${weather.rainyPercent}%',
                              //   style: TextStyle(color: Colors.lightBlueAccent),
                              // ),
                              Image.network(
                                  "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                                  width: 30),
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
            dailyWeather == []
                ? Container()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                            children: dailyWeather.map((weather) {
                          return Container(
                            height: 50,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 50,
                                      child: Text(
                                          '${weekDay[weather.time!.weekday - 1]}曜日')),
                                  Row(
                                    children: [
                                      Container(width: 35),
                                      Image.network(
                                          "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                                          width: 30),
                                      Container(
                                        width: 35,
                                        child: Text('${weather.rainyPercent}%',
                                            style: TextStyle(
                                                color: Colors.lightBlueAccent)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${weather.tempMax}',
                                            style: TextStyle(fontSize: 16)),
                                        Text('${weather.tempMin}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black
                                                    .withOpacity(0.4))),
                                      ],
                                    ),
                                  ),
                                ]),
                          );
                        }).toList()),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
