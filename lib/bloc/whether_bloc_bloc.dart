import 'package:bloc/bloc.dart';
import 'package:wether_app/bloc/whether_bloc_event.dart';
import 'package:wether_app/bloc/whether_bloc_state.dart';
import 'package:wether_app/repository/repo.dart';
import 'package:video_player/video_player.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  VideoPlayerController? _videoController;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(
        WeatherLoading(
          videoController: _videoController,
          videoInitialized: _videoController?.value.isInitialized ?? false,
        ),
      );
      try {
        final weather = await weatherRepository.fetchWeather(event.cityName);
        emit(
          WeatherLoaded(
            weather,
            videoController: _videoController,
            videoInitialized: _videoController?.value.isInitialized ?? false,
          ),
        );
      } catch (e) {
        emit(
          WeatherError(
            'Could not fetch weather',
            videoController: _videoController,
            videoInitialized: _videoController?.value.isInitialized ?? false,
          ),
        );
      }
    });

    on<InitVideo>((event, emit) async {
      _videoController = VideoPlayerController.asset('lib/assets/bgdv.mp4');
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.setVolume(0);
      await _videoController!.play();
      emit(
        WeatherLoading(
          videoController: _videoController,
          videoInitialized: true,
        ),
      );
    });

    on<PlayVideo>((event, emit) async {
      if (_videoController != null && !_videoController!.value.isPlaying) {
        await _videoController!.play();
        emit(
          WeatherLoading(
            videoController: _videoController,
            videoInitialized: _videoController!.value.isInitialized,
          ),
        );
      }
    });

    on<PauseVideo>((event, emit) async {
      if (_videoController != null && _videoController!.value.isPlaying) {
        await _videoController!.pause();
        emit(
          WeatherLoading(
            videoController: _videoController,
            videoInitialized: _videoController!.value.isInitialized,
          ),
        );
      }
    });

    on<DisposeVideo>((event, emit) async {
      await _videoController?.dispose();
      _videoController = null;
      emit(WeatherLoading(videoController: null, videoInitialized: false));
    });
  }
}
