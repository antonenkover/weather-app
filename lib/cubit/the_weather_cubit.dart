import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:study/model/weather_model.dart';
import 'package:study/services/weather_service.dart';

part 'the_weather_state.dart';

class TheWeatherCubit extends Cubit<TheWeatherState> {
  final AbstractWeatherService _weatherService;

  TheWeatherCubit(this._weatherService) : super(TheWeatherInitial());

  Future<void> getWeather(String cityName, String locale) async {
    try {
      emit(TheWeatherLoading());
      final weather = await _weatherService.fetchDataForCity(cityName, locale);
      emit(TheWeatherLoaded(weather));
    } on SomeError {
      emit(TheWeatherError('data error'.tr().toString()));
    }
  }

  Future<void> getDetailedWeather(String cityName, String locale) async {
    try {
      emit(TheWeatherLoading());
      final weather =
          await _weatherService.fetchDetailedDataForCity(cityName, locale);
      emit(TheWeatherLoaded(weather));
    } on SomeError {
      emit(TheWeatherError('data error'.tr().toString()));
    }
  }

  Future<void> getLocationWeather(String locale) async {
    try {
      emit(TheWeatherLoading());
      final weather = await _weatherService.fetchDataForLocation(locale);
      emit(TheWeatherLoaded(weather));
    } on SomeError {
      emit(TheWeatherError('error'.tr().toString()));
    }
  }
}
