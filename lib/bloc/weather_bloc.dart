import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:study/services/weather_service.dart';

import '../model/weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final AbstractWeatherService _weatherService;

  WeatherBloc(this._weatherService) : super(null);

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();
    if (event is GetWeatherData) {
      try {
        Weather weather = await _weatherService.fetchDataForCity(
            event.cityName, event.locale);
        yield WeatherLoaded(weather);
      } on SomeError {
        yield WeatherError('data error'.tr().toString());
      }
    } else if (event is GetLocationWeatherData) {
      try {
        Weather weather =
            await _weatherService.fetchDataForLocation(event.locale);
        yield WeatherLoaded(weather);
      } on SomeError {
        yield WeatherError('data error'.tr().toString());
      }
    } else if (event is GetDetailedWeatherData) {
      try {
        Weather weather = await _weatherService.fetchDetailedDataForCity(
            event.cityName, event.locale);
        yield WeatherLoaded(weather);
      } on SomeError {
        yield WeatherError('data error'.tr().toString());
      }
    }
  }
}
