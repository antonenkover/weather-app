import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Weather extends Equatable {
  final String cityName;
  final int celciusTemperature;
  final int farenheitTemperature;
  final String conditionImage;
  final String description;

  Weather(
      {@required this.cityName,
      @required this.celciusTemperature,
      this.farenheitTemperature,
      this.conditionImage,
      this.description});

  @override
  List<Object> get props => [
        cityName,
        celciusTemperature,
        farenheitTemperature,
        conditionImage,
        description
      ];
}
//
//enum WeatherCondition {
//  thunderstorm,
//  drizzle,
//  rain,
//  snow,
//  atmosphere,
//  clear,
//  clouds,
//}
