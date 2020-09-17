class City {
  final String cityName;

  City({this.cityName});

  factory City.fromJson(Map<String, dynamic> parseJson) {
    return City(cityName: parseJson['name']);
  }
}

class ManyCities {
  final List<City> listCity;

  ManyCities({this.listCity});

  factory ManyCities.fromJson(List<dynamic> parsedJson) {
    List<City> listCity = new List<City>();
    listCity = parsedJson.map((i) => City.fromJson(i)).toList();

    return new ManyCities(
      listCity: listCity,
    );
  }
}
