part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeatherData extends WeatherEvent {
  final String cityName;
  final String locale;

  GetWeatherData(this.cityName, this.locale);

  @override
  List<Object> get props => [cityName, locale];
}

class GetLocationWeatherData extends WeatherEvent {
  final String locale;

  GetLocationWeatherData(this.locale);

  @override
  List<Object> get props => [locale];
}

class GetDetailedWeatherData extends WeatherEvent {
  final String cityName;
  final String locale;

  GetDetailedWeatherData(this.cityName, this.locale);

  @override
  List<Object> get props => [cityName, locale];
}
