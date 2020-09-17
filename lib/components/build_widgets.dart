import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:study/components/typeahead_city_search.dart';

import 'animated_weather_image.dart';

class BuildInitialInput extends StatefulWidget {
  @override
  _BuildInitialInputState createState() => _BuildInitialInputState();
}

class _BuildInitialInputState extends State<BuildInitialInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
        Expanded(child: TypeAheadSearchCity()),
        Expanded(
          flex: 2,
          child: AnimatedWeatherImage('assets/weatherIcons/rainbow.png'),
        ),
        Expanded(
          child: Center(
            child: Text(
              'title'.tr().toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
