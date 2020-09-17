import 'dart:convert';

import 'package:flutter/services.dart';

import 'city.dart';

class CityModel {
  static List<City> cities;
  static List<String> listCity;

  static Future loadCitiesData() async {
    try {
      cities = new List<City>();
      listCity = new List<String>();
      String jsonString = await rootBundle.loadString('assets/cityList.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson["cities"] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        listCity.add(new City.fromJson(categoryJson[i]).cityName);
      }
    } catch (e) {
      print(e);
    }
  }
}
