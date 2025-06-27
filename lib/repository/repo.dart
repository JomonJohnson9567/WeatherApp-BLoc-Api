import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wether_app/model/model.dart';

class WeatherRepository {
  final apiKey = 'c51a217a8bb4d5e62a69b8d541c85878';
  final basicUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=Kochi&appid=c51a217a8bb4d5e62a69b8d541c85878'; // Replace with your OpenWeatherMap API key

  Future<WeatherModel> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(basicUrl));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
