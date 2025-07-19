import 'package:flutter/material.dart';
import 'package:wether_app/presentation/home/widgets/info_card_widget.dart';

class WeatherInfoRows extends StatelessWidget {
  final dynamic weather;
  final String Function(int) formatTime;
  // ignore: use_super_parameters
  const WeatherInfoRows({
    Key? key,
    required this.weather,
    required this.formatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoCard(
              label: 'Feels Like',
              value: '${(weather.feelsLike - 271.15).toStringAsFixed(1)}°C',
            ),
            InfoCard(label: 'Humidity', value: '${weather.humidity}%'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoCard(
              label: 'Wind',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            InfoCard(label: 'Pressure', value: '${weather.pressure} hPa'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoCard(
              label: 'Min Temp',
              value: '${(weather.minTemp - 271.15).toStringAsFixed(1)}°C',
            ),
            InfoCard(
              label: 'Max Temp',
              value: '${(weather.maxTemp - 271.15).toStringAsFixed(1)}°C',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoCard(label: 'Sunrise', value: formatTime(weather.sunrise)),
            InfoCard(label: 'Sunset', value: formatTime(weather.sunset)),
          ],
        ),
      ],
    );
  }
}
