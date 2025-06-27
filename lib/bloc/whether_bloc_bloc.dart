import 'package:bloc/bloc.dart';
import 'package:wether_app/bloc/whether_bloc_event.dart';
import 'package:wether_app/bloc/whether_bloc_state.dart';
import 'package:wether_app/repository/repo.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await weatherRepository.fetchWeather(event.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError('Could not fetch weather'));
      }
    });
  }
}
