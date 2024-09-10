import 'dart:convert';

import 'package:application/models/city.dart';
import 'package:application/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherServices {
  Future<void> saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', location);
  }

  Future<dynamic> getInfotmation(String city) async {
    Uri url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=353124e7e27814f76fb4c773a6a9ac82");

    List<Weather> loadedWeather = [];

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      City.selectedCity = data['city']['name'];
      saveString(City.selectedCity);
      await saveLocation(City.selectedCity);
      data['list'].forEach((value) {
        loadedWeather.add(Weather.fromJson(value));
      });
    } catch (e) {
      return "shaxar mavjud emas";
    }

    return loadedWeather;
  }
}

Future<void> saveString(String city) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('selectedCityForApp', city);
}
