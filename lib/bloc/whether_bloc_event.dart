abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String cityName;

  FetchWeather(this.cityName);
}

class InitVideo extends WeatherEvent {}

class PlayVideo extends WeatherEvent {}

class PauseVideo extends WeatherEvent {}

class DisposeVideo extends WeatherEvent {}
