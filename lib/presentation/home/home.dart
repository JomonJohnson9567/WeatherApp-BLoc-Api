import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:wether_app/bloc/whether_bloc_bloc.dart';
import 'package:wether_app/bloc/whether_bloc_event.dart';
import 'package:wether_app/bloc/whether_bloc_state.dart';
import 'package:wether_app/presentation/home/widgets/weather_info_row_widget.dart';
import 'package:wether_app/presentation/home/widgets/weather_main_info_widget.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  String formatTime(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final videoController =
            (state is WeatherVideoState) ? state.videoController : null;
        final videoInitialized =
            (state is WeatherVideoState) ? state.videoInitialized : false;

        // Dispatch InitVideo and FetchWeather only if not initialized
        if (videoController == null && videoInitialized == false) {
          context.read<WeatherBloc>().add(InitVideo());
          context.read<WeatherBloc>().add(FetchWeather('Kochi'));
        }

        return Scaffold(
          body: Stack(
            children: [
              // Background MP4 video
              if (videoController != null && videoInitialized)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoController.value.size.width,
                      height: videoController.value.size.height,
                      child: VideoPlayer(videoController),
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
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        WeatherMainInfo(weather: weather),
                                        const SizedBox(height: 30),
                                        WeatherInfoRows(
                                          weather: weather,
                                          formatTime: formatTime,
                                        ),
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
      },
    );
  }
}
