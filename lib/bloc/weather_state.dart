part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
