import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study/model/city.dart';
import 'package:study/model/city_model.dart';
import 'package:study/cubit/the_weather_cubit.dart';

//баги в самом пакете autocompleteTextField :c

class CitySearchInput extends StatefulWidget {
  @override
  _CitySearchInputState createState() => _CitySearchInputState();
}

class _CitySearchInputState extends State<CitySearchInput> {
  String hintText;

  void _loadData() async {
    await CityModel.loadCitiesData();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  GlobalKey<AutoCompleteTextFieldState<City>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _CitySearchInputState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (searchTextField.textField.controller.text.isNotEmpty) {
                  submitCityName(
                      context, searchTextField.textField.controller.text);
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('empty city snackbar'.tr().toString()),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.indigo,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: searchTextField = AutoCompleteTextField<City>(
                    suggestionsAmount: 5,
                    style: new TextStyle(fontSize: 16.0),
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'hint text'.tr().toString(),
                    ),
                    itemSubmitted: (item) {
                      setState(() {
                        if (!mounted) return;
                        searchTextField.textField.controller.text =
                            item.cityName;
                      });
                    },
                    clearOnSubmit: false,
                    key: key,
                    suggestions: CityModel.cities,
                    itemBuilder: (context, item) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.cityName.toLowerCase(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemSorter: (a, b) {
                      return a.cityName.compareTo(b.cityName);
                    },
                    itemFilter: (item, query) {
                      return item.cityName
                          .toLowerCase()
                          .startsWith(query.toLowerCase());
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  submitGeolocation(context);
                },
                child: Icon(
                  Icons.location_on,
                  color: Colors.indigo,
                  size: MediaQuery.of(context).size.height * 0.05,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void submitGeolocation(BuildContext context) {
    final weatherCubit = context.bloc<TheWeatherCubit>();
    weatherCubit.getLocationWeather(context.locale.languageCode);
  }

  void submitCityName(BuildContext context, String cityName) {
    final weatherCubit = context.bloc<TheWeatherCubit>();
    weatherCubit.getWeather(cityName, context.locale.languageCode);
//    BlocProvider.of<WeatherBloc>(context).add(GetWeatherData(cityName));
  }
}
