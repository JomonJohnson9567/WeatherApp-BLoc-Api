import 'package:wether_app/model/model.dart';
import 'package:video_player/video_player.dart';

abstract class WeatherState {}

abstract class WeatherVideoState extends WeatherState {
  final VideoPlayerController? videoController;
  final bool videoInitialized;
  WeatherVideoState({this.videoController, this.videoInitialized = false});
}

class WeatherInitial extends WeatherVideoState {
  // ignore: use_super_parameters
  WeatherInitial({
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}

class WeatherLoading extends WeatherVideoState {
  // ignore: use_super_parameters
  WeatherLoading({
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}

class WeatherLoaded extends WeatherVideoState {
  final WeatherModel weather;
  // ignore: use_super_parameters
  WeatherLoaded(
    this.weather, {
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}

class WeatherError extends WeatherVideoState {
  final String message;
  // ignore: use_super_parameters
  WeatherError(
    this.message, {
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}
