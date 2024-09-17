import 'dart:convert';
import 'package:weather_app_yandex_api/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherApi {
  Future<Weather> getWeather(String lat, String lon) async {
    final String url =
        "https://api.weather.yandex.ru/v2/forecast?lat=$lat&lon=$lon";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        "X-Yandex-Weather-Key": "e0440c95-7af6-4ad6-bc13-86209dccf405",
      },
    );
    Map data = jsonDecode(response.body);
    return Weather.fromJson(data);
  }
}
