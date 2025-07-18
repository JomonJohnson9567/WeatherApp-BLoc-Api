import 'package:flutter/material.dart';

class WeatherMainInfo extends StatelessWidget {
  final dynamic weather;
  const WeatherMainInfo({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          weather.description.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Image.network(
          'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
          width: 100,
          height: 100,
        ),
        Text(
          '${(weather.temperature - 273.15).toStringAsFixed(0)}°C',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
