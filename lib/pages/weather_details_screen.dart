import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:study/components/animated_weather_image.dart';
import 'package:study/components/build_widgets.dart';
import 'package:study/model/weather_model.dart';
import 'package:study/cubit/the_weather_cubit.dart';
import 'package:study/states_rebuilder/weather_store.dart';
import 'package:study/utilities/constants.dart';

class WeatherDetailsScreen extends StatefulWidget {
  final Weather weather;

  const WeatherDetailsScreen({Key key, this.weather}) : super(key: key);

  @override
  _WeatherDetailsScreenState createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  @override
  void didChangeDependencies() {
    final reactiveModel = Injector.getAsReactive<WeatherStore>();
    reactiveModel.setState((s) => s.getDetailedWeather(
        widget.weather.cityName, context.locale.languageCode));

//    final weatherCubit = context.bloc<TheWeatherCubit>();
//    weatherCubit.getDetailedWeather(
//        widget.weather.cityName, context.locale.languageCode);

//    BlocProvider.of<WeatherBloc>(context)
//        .add(GetDetailedWeatherData(widget.weather.cityName));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
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
//          BlocConsumer<TheWeatherCubit, TheWeatherState>(
//            listener: (context, state) {
//              if (state is TheWeatherError) {
//                Scaffold.of(context).showSnackBar(
//                  SnackBar(
//                    content: Text('error'.tr().toString()),
//                  ),
//                );
//              }
//            },
//            // ignore: missing_return
//            builder: (context, state) {
//              if (state is TheWeatherLoading) {
//                return buildLoading();
//              } else if (state is TheWeatherLoaded) {
//                return buildColumnWithWeatherData(context, state.weather);
//              }
//            },
//          ),
        ),
      ),
    );
  }

  Center buildColumnWithWeatherData(BuildContext context, Weather weather) {
    final String addText = context.locale.languageCode == 'en' ? 'IN' : 'В:';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          AnimatedWeatherImage(weather.conditionImage),
          Text(
            '${weather.description.toUpperCase()} $addText ${weather.cityName.toUpperCase()}',
            style: kWhiteTextStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            '${weather.celciusTemperature.toString()} °C',
            style: kWhiteTextStyle,
          ),
          Text(
            '${weather.farenheitTemperature.toString()} °F',
            style: kWhiteTextStyle,
          ),
        ],
      ),
    );
  }
}
