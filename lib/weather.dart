import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'location.dart';

const apiKey='da41f91150e6b8039c1294055206df0d';

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({required this.weatherIcon, required this.weatherImage});
}

class WeatherData {
  LocationHelper locationData;
   WeatherData({required this.locationData});


  late double currentTemperature;
  late int currentCondition;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric'));

    if (response.statusCode == 200) {
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: const Icon(
          FontAwesomeIcons.cloud,
          size: 75.0,
          color: Colors.white,
        ),
        weatherImage: AssetImage('assets/images/cloudy.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/images/night.png'),
          weatherIcon: Icon(
            FontAwesomeIcons.moon,
            size: 75.0,
            color: Colors.white,
          ),
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: Icon(
            FontAwesomeIcons.sun,
            size: 75.0,
            color: Colors.white,
          ),
          weatherImage: AssetImage('assets/images/sunny.png'),
        );
      }
    }
  }
}