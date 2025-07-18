import 'package:wether_app/model/model.dart';
import 'package:video_player/video_player.dart';

abstract class WeatherState {}

abstract class WeatherVideoState extends WeatherState {
  final VideoPlayerController? videoController;
  final bool videoInitialized;
  WeatherVideoState({this.videoController, this.videoInitialized = false});
}

class WeatherInitial extends WeatherVideoState {
  WeatherInitial({
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}

class WeatherLoading extends WeatherVideoState {
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
  WeatherError(
    this.message, {
    VideoPlayerController? videoController,
    bool videoInitialized = false,
  }) : super(
         videoController: videoController,
         videoInitialized: videoInitialized,
       );
}
