import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:study/model/city_model.dart';
import 'package:study/cubit/the_weather_cubit.dart';
import 'package:study/services/weather_service.dart';
import 'package:study/states_rebuilder/weather_store.dart';

class TypeAheadSearchCity extends StatefulWidget {
  @override
  _TypeAheadSearchCityState createState() => _TypeAheadSearchCityState();
}

class _TypeAheadSearchCityState extends State<TypeAheadSearchCity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  void _loadData() async {
    await CityModel.loadCitiesData();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this._formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (this._formKey.currentState.validate()) {
                submitCityName(context, this._typeAheadController.text);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: Icon(
                Icons.search,
                color: Colors.indigo,
                size: MediaQuery.of(context).size.height * 0.06,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: buildTypeAheadFormField(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: GestureDetector(
              onTap: () {
                submitGeolocation(context);
              },
              child: Icon(
                Icons.location_on,
                color: Colors.indigo,
                size: MediaQuery.of(context).size.height * 0.06,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TypeAheadFormField<String> buildTypeAheadFormField() {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        textCapitalization: TextCapitalization.words,
        cursorColor: Colors.indigo,
        decoration: InputDecoration(
          hintText: 'hint text'.tr().toString(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        controller: this._typeAheadController,
      ),
      hideOnError: true,
      hideSuggestionsOnKeyboardHide: true,
      keepSuggestionsOnSuggestionSelected: false,
      suggestionsCallback: (pattern) async {
        return CityModel.listCity
            .where(
                (item) => item.toLowerCase().startsWith(pattern.toLowerCase()))
            .toList();
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.grey[700].withOpacity(0.7),
        constraints: BoxConstraints.loose(
          Size.fromHeight(100),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (context, suggestion) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          child: Text(
            suggestion,
            style: TextStyle(
              fontSize: 15.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      noItemsFoundBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'no items'.tr().toString(),
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController.text = suggestion;
      },
      validator: (value) =>
          value.isEmpty ? 'empty city snackbar'.tr().toString() : null,
    );
  }

  void submitGeolocation(BuildContext context) {
    final reactiveModel = Injector.getAsReactive<WeatherStore>();
    reactiveModel
        .setState((s) => s.getLocationWeather(context.locale.languageCode),
            onError: (context, error) {
      if (error is SomeError) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('error'.tr().toString()),
          ),
        );
      } else
        throw error;
    });

//    final weatherCubit = context.bloc<TheWeatherCubit>();
//    weatherCubit.getLocationWeather(context.locale.languageCode);
  }

  void submitCityName(BuildContext context, String cityName) {
    final reactiveModel = Injector.getAsReactive<WeatherStore>();
    reactiveModel
        .setState((s) => s.getWeather(cityName, context.locale.languageCode),
            onError: (context, error) {
      if (error is SomeError) {
        RM.scaffold.showSnackBar(
          SnackBar(
            content: Text(
              'error'.tr().toString(),
            ),
          ),
        );
      } else
        throw error;
    });

//    final weatherCubit = context.bloc<TheWeatherCubit>();
//    weatherCubit.getWeather(cityName, context.locale.languageCode);

//    BlocProvider.of<WeatherBloc>(context).add(GetWeatherData(cityName));
  }
}
