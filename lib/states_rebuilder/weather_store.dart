import 'package:study/model/weather_model.dart';
import 'package:study/services/weather_service.dart';

class WeatherStore {
  final AbstractWeatherService _weatherService;

  WeatherStore(this._weatherService);

  Weather _weather;
  Weather get weather => _weather;

  void getWeather(String cityName, String locale) async {
    _weather = await _weatherService.fetchDataForCity(cityName, locale);
  }

  void getDetailedWeather(String cityName, String locale) async {
    _weather = await _weatherService.fetchDetailedDataForCity(cityName, locale);
  }

  void getLocationWeather(String locale) async {
    _weather = await _weatherService.fetchDataForLocation(locale);
  }
}
