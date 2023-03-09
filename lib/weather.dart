import 'dart:convert';

import 'package:http/http.dart';

class Weather {
  int? temp; //気温
  int? tempMax; //最高気温
  int? tempMin; //最低気温
  String? description; //天気状態
  double? lon; //緯度
  double? lat; //軽度
  String? icon; //天気情報のアイコン画像
  DateTime? time; //日時
  int? rainyPercent; //降水確率

  Weather({
    this.temp,
    this.tempMax,
    this.tempMin,
    this.description,
    this.lon,
    this.lat,
    this.icon,
    this.time,
    this.rainyPercent,
  });

  static String apikey = "";
  static String publicParameter = "&appid=$apikey&lang=ja&units=metric";
  static Future<Weather?> getCurrentWeather(String zipCode) async {
    String _zipCode = "";
    if (zipCode.contains('-')) {
      _zipCode = zipCode;
    } else {
      _zipCode = '${zipCode.substring(0, 3)}-${zipCode.substring(3)}';
    }
    print(_zipCode);
    String url =
        "https://api.openweathermap.org/data/2.5/weather?zip=$_zipCode,JP$publicParameter";
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      print("getCurrentWeather data $data");
      double? temp = data["main"]["temp"];
      double? tempMax = data["main"]["temp_max"];
      double? tempMin = data["main"]["temp_min"];
      Weather currentWeather = Weather(
          description: data["weather"][0]["description"],
          temp: temp?.toInt(),
          tempMax: tempMax?.toInt(),
          tempMin: tempMin?.toInt(),
          lon: data["coord"]["lon"],
          lat: data["coord"]["lat"]);
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<Map<String, List<Weather>>?> getForecast(
      {required double lat, required double lon}) async {
    Map<String, List<Weather>> response = {};
    String url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely&$publicParameter";
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      List<dynamic> hourlyWeatherData = data["hourly"];
      List<dynamic> dailyWeatherData = data["daily"];
      List<Weather> hourlyWeather = hourlyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather["dt"] * 1000),
          temp: weather["temp"].toInt(),
          icon: weather["weather"][0]["icon"],
        );
      }).toList();
      List<Weather> dailyWeather = dailyWeatherData.map((weather) {
        return Weather(
          time: DateTime.fromMillisecondsSinceEpoch(weather["dt"] * 1000),
          icon: weather["weather"][0]["icon"],
          tempMax: weather["temp"]["max"].toInt(),
          tempMin: weather["temp"]["min"].toInt(),
          rainyPercent:
              weather.containsKey("rain") ? weather["rain"].toInt() : 0,
        );
      }).toList();
      print(dailyWeather[0]);
      response["hourly"] = hourlyWeather;
      response["daily"] = dailyWeather;
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
