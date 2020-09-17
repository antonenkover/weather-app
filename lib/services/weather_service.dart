import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:study/model/weather_model.dart';

abstract class AbstractWeatherService {
  Future<Weather> fetchDataForCity(String cityName, String locale);

  Future<Weather> fetchDetailedDataForCity(String cityName, String locale);

  Future<Weather> fetchDataForLocation(String locale);
}

class WeatherService implements AbstractWeatherService {
  static const String apiKey = 'API_KEY';
  static const String webAddress =
      'http://api.openweathermap.org/data/2.5/weather';
  var celciusCashed;
  int condition;
  String weatherImage;

  @override
  Future<Weather> fetchDataForCity(String cityName, String locale) async {
    String url = '$webAddress?q=$cityName&appid=$apiKey&units=metric';
    http.Response response =
        await http.get(locale == 'en' ? url : '$url&lang=ru');
    String description;
    if (response.statusCode == 200) {
      dynamic data = await jsonDecode(response.body);
      celciusCashed = data['main']['temp'];
      int condition = data['weather'][0]['id'];
      weatherImage = getWeatherImage(condition);
      description = data['weather'][0]['description'];
      cityName = data['name'];
    } else
      throw SomeError();
    return Weather(
        cityName: cityName,
        celciusTemperature: celciusCashed.round(),
        conditionImage: weatherImage,
        description: description);
  }

  @override
  Future<Weather> fetchDetailedDataForCity(
      String cityName, String locale) async {
    String url = '$webAddress?q=$cityName&appid=$apiKey&units=imperial';
    http.Response response =
        await http.get(locale == 'en' ? url : '$url&lang=ru');
    var farenheitTemp;
    String description;
    if (response.statusCode == 200) {
      dynamic data = await jsonDecode(response.body);
      farenheitTemp = data['main']['temp'];
      cityName = data['name'];
      description = data['weather'][0]['description'];
    } else
      throw SomeError();
    return Weather(
        cityName: cityName,
        celciusTemperature: celciusCashed.round(),
        farenheitTemperature: farenheitTemp.round(),
        conditionImage: weatherImage,
        description: description);
  }

  @override
  Future<Weather> fetchDataForLocation(String locale) async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    String url =
        '$webAddress?lat=${position.latitude.toString()}&lon=${position.longitude.toString()}&appid=$apiKey&units=metric';
    http.Response response =
        await http.get(locale == 'en' ? url : '$url&lang=ru');
    String cityName;
    String description;
    if (response.statusCode == 200) {
      dynamic data = await jsonDecode(response.body);
      celciusCashed = data['main']['temp'];
      cityName = data['name'];
      condition = data['weather'][0]['id'];
      weatherImage = getWeatherImage(condition);
      description = data['weather'][0]['description'];
    } else
      throw SomeError();
    return Weather(
        cityName: cityName,
        celciusTemperature: celciusCashed.round(),
        conditionImage: weatherImage,
        description: description);
  }

  String getWeatherImage(int condition) {
    if (condition < 300) {
      return 'assets/weatherIcons/storm.png';
    } else if (condition < 400) {
      return 'assets/weatherIcons/drizzle.png';
    } else if (condition > 400 && condition < 505) {
      return 'assets/weatherIcons/light_rain.png';
    } else if (condition < 600 && condition != 511) {
      return 'assets/weatherIcons/heavy_rain.png';
    } else if (condition < 700 || condition == 511) {
      return 'assets/weatherIcons/snowflakes.png';
    } else if (condition < 800) {
      return 'assets/weatherIcons/fog.png';
    } else if (condition == 800) {
      return 'assets/weatherIcons/sun.png';
    } else if (condition == 801) {
      return 'assets/weatherIcons/cloudy.png';
    } else if (condition == 802) {
      return 'assets/weatherIcons/cloudy2.png';
    } else if (condition < 805) {
      return 'assets/weatherIcons/cloudy3.png';
    } else {
      return 'assets/weatherIcons/compass.png';
    }
  }
}

class SomeError extends Error {}
