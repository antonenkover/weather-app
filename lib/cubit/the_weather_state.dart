part of 'the_weather_cubit.dart';

abstract class TheWeatherState extends Equatable {
  const TheWeatherState();
}

class TheWeatherInitial extends TheWeatherState {
  @override
  List<Object> get props => [];
}

class TheWeatherLoading extends TheWeatherState {
  @override
  List<Object> get props => [];
}

class TheWeatherLoaded extends TheWeatherState {
  final Weather weather;

  TheWeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class TheWeatherError extends TheWeatherState {
  final String message;

  TheWeatherError(this.message);

  @override
  List<Object> get props => [message];
}
