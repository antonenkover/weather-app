import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:study/pages/weather_main_screen.dart';
import 'package:study/services/weather_service.dart';
import 'package:study/cubit/the_weather_cubit.dart';
import 'package:study/states_rebuilder/weather_store.dart';

void main() => runApp(EasyLocalization(
    path: "assets/translations",
    supportedLocales: <Locale>[Locale('en', 'EN'), Locale('ru', 'RU')],
    saveLocale: true,
    startLocale: Locale('en', 'EN'),
    child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigo,
      ),
      home: Injector(
        inject: [Inject<WeatherStore>(() => WeatherStore(WeatherService()))],
        builder: (_) => WeatherMainScreen(),
      ),
//      BlocProvider(
//          create: (context) => TheWeatherCubit(WeatherService()),
//          child: WeatherMainScreen()),
    );
  }
}
