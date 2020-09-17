import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:study/components/animated_weather_image.dart';
import 'package:study/components/build_widgets.dart';
import 'package:study/components/typeahead_city_search.dart';
import 'package:study/model/weather_model.dart';
import 'package:study/pages/weather_details_screen.dart';
import 'package:study/cubit/the_weather_cubit.dart';
import 'package:study/states_rebuilder/weather_store.dart';
import 'package:study/utilities/constants.dart';
//import 'package:study/components/city_search_textfield.dart';

class WeatherMainScreen extends StatefulWidget {
  @override
  _WeatherMainScreenState createState() => _WeatherMainScreenState();
}

class _WeatherMainScreenState extends State<WeatherMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: StateBuilder<WeatherStore>(
                  observe: () => RM.get<WeatherStore>(),
                  builder: (_, reactiveModel) {
                    return reactiveModel.whenConnectionState(
                        onIdle: () => BuildInitialInput(),
                        onWaiting: () => BuildLoading(),
                        onData: (weather) => buildColumnWithWeatherData(
                            context, reactiveModel.state.weather),
                        onError: (_) => BuildInitialInput());
                  },
                ),
//                BlocConsumer<TheWeatherCubit, TheWeatherState>(
//                  listener: (context, state) {
//                    if (state is TheWeatherError) {
//                      Scaffold.of(context).showSnackBar(
//                        SnackBar(
//                          content: Text('error'.tr().toString()),
//                        ),
//                      );
//                    }
//                  },
//                  builder: (context, state) {
//                    if (state is TheWeatherLoading) {
//                      return buildLoading();
//                    } else if (state is TheWeatherLoaded) {
//                      return buildColumnWithWeatherData(context, state.weather);
//                    } else {
//                      return buildInitialInput();
//                    }
//                  },
//                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildColumnWithWeatherData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    EasyLocalization.of(context).locale = Locale('ru', 'RU');
                  });
                },
                child: Image(
                  image: AssetImage('assets/weatherIcons/rus.png'),
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    EasyLocalization.of(context).locale = Locale('en', 'EN');
                  });
                },
                child: Image(
                  image: AssetImage('assets/weatherIcons/usa.png'),
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 15,
          ),
          child: TypeAheadSearchCity(),
        ),
        Expanded(
          child: AnimatedWeatherImage(weather.conditionImage),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            weather.cityName.toUpperCase(),
            textAlign: TextAlign.center,
            style: kWhiteTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${weather.celciusTemperature.toString()} °C',
            style: kWhiteTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            color: Colors.indigo,
            onPressed: () {
              RM.navigator.push(
                MaterialPageRoute(
                  builder: (context) => WeatherDetailsScreen(
                    weather: weather,
                  ),
                ),
              );

//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (_) =>
//                      BlocProvider.value(
//                    value: BlocProvider.of<TheWeatherCubit>(context),
//                    child: WeatherDetailsScreen(
//                      weather: weather,
//                    ),
//                  ),
//                ),
//              );
            },
            child: Text('details'.tr()),
          ),
        ),
      ],
    );
  }
}
