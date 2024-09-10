// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      main: json['main'] as Map<String, dynamic>,
      weather: json['weather'] as List<dynamic>,
      wind: json['wind'] as Map<String, dynamic>,
      dt_txt: DateTime.parse(json['dt_txt'] as String),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'main': instance.main,
      'weather': instance.weather,
      'wind': instance.wind,
      'dt_txt': instance.dt_txt.toIso8601String(),
    };
