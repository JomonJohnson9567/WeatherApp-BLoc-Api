import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wether_app/bloc/whether_bloc_bloc.dart';
import 'package:wether_app/bloc/whether_bloc_event.dart';
import 'package:wether_app/bloc/whether_bloc_state.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('lib/assets/bgdv.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // mute the video
        _controller.play();
      });

    // Fetch weather for Kochi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherBloc>().add(FetchWeather('Kochi'));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Background MP4 video
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),

          // Dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xAA0D1B2A), Color(0xCC1B263B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'WeatherView',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Center(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<WeatherBloc>().add(
                            FetchWeather('Kochi'),
                          );
                        },
                        child: BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, state) {
                            if (state is WeatherLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 30,
                                  color: Color.fromARGB(255, 115, 188, 218),
                                ),
                              );
                            } else if (state is WeatherLoaded) {
                              final weather = state.weather;
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
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
                                    const SizedBox(height: 30),
                                    _buildInfoRow(weather),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            } else if (state is WeatherError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(weather) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoCard(
              label: 'Feels Like',
              value: '${(weather.feelsLike - 271.15).toStringAsFixed(1)}°C',
            ),
            _infoCard(label: 'Humidity', value: '${weather.humidity}%'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoCard(
              label: 'Wind',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            _infoCard(label: 'Pressure', value: '${weather.pressure} hPa'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoCard(
              label: 'Min Temp',
              value: '${(weather.minTemp - 271.15).toStringAsFixed(1)}°C',
            ),
            _infoCard(
              label: 'Max Temp',
              value: '${(weather.maxTemp - 271.15).toStringAsFixed(1)}°C',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _infoCard(label: 'Sunrise', value: formatTime(weather.sunrise)),
            _infoCard(label: 'Sunset', value: formatTime(weather.sunset)),
          ],
        ),
      ],
    );
  }

  Widget _infoCard({required String label, required String value}) {
    return Container(
      width: 140,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
