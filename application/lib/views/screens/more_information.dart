import 'package:application/models/city.dart';
import 'package:application/models/weather.dart';
import 'package:application/services/weather_services_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MoreInformationScreen extends StatefulWidget {
  const MoreInformationScreen({super.key});

  @override
  State<MoreInformationScreen> createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  WeatherServices weatherController = WeatherServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFF1D2547),
                    Color(0xFF1D2547),
                    Color.fromARGB(255, 103, 63, 184),
                    Color.fromARGB(255, 178, 123, 189),
                  ])),
              child: FutureBuilder(
                  future: weatherController.getInfotmation(City.selectedCity),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    final List<Weather> weathers = snapshot.data;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          Text(City.selectedCity,
                              style: GoogleFonts.poppins(
                                  fontSize: 25.h,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  "Max: ${(weathers[0].main['temp_max'] - 272) ~/ 1}°",
                                  style: GoogleFonts.poppins(
                                      fontSize: 25.h,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(
                                width: 30.w,
                              ),
                              Text(
                                  "Min: ${(weathers[0].main['temp_min'] - 272) ~/ 1}°",
                                  style: GoogleFonts.poppins(
                                      fontSize: 25.h,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 30, 45, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("DAILY FORECASTS",
                                    style: GoogleFonts.poppins(
                                        fontSize: 25.h,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromARGB(0, 3, 3, 68),
                                        blurRadius: 50)
                                  ],
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color.fromARGB(255, 103, 63, 184),
                                        Color.fromARGB(255, 42, 56, 110),
                                      ])),
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      daysInformation(weathers[0]),
                                      for (var i = 1; i < weathers.length; i++)
                                        weathers[i].dt_txt.day >
                                                weathers[i - 1].dt_txt.day
                                            ? daysInformation(weathers[i])
                                            : const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xff3E2D8F),
                                        Color(0xff8E78C8),
                                      ])),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Humidity: ${weathers[0].main['humidity']}%",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20.h,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                      "Wind speed: ${weathers[0].wind['speed']}m/s",
                                      style: GoogleFonts.poppins(
                                          fontSize: 20.h,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "Air pressure: ${weathers[0].main['pressure']} m/bars",
                                    style: GoogleFonts.poppins(
                                        fontSize: 20.h,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }))),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 178, 123, 189),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.line_horizontal_3,
                  color: Colors.white,
                  size: 60,
                )),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}

Widget daysInformation(Weather weather) {
  return Row(
    children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xff3E2D8F),
                  Color(0xff8E78C8),
                ])),
        padding: const EdgeInsets.fromLTRB(7, 15, 7, 15),
        height: 150.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${(weather.main['temp'] - 272) ~/ 1}℃",
                style: GoogleFonts.poppins(
                    fontSize: 18.h,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            SizedBox(
                width: 50.w,
                child: Image.asset(
                  "assets/images/${weather.weather[0]['icon']}.png",
                  fit: BoxFit.cover,
                )),
            Text(getWeekDay(weather.dt_txt.weekday),
                style: GoogleFonts.poppins(
                    fontSize: 18.h,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      const SizedBox(width: 40)
    ],
  );
}

String getWeekDay(int weekDayNumber) {
  switch (weekDayNumber) {
    case DateTime.monday:
      return "Mon";
    case DateTime.tuesday:
      return "Tue";
    case DateTime.wednesday:
      return "Wed";
    case DateTime.thursday:
      return "Thu";
    case DateTime.friday:
      return "Fri";
    case DateTime.saturday:
      return "Sat";
    case DateTime.sunday:
      return "Sun";
    default:
      return "Noma'lum kun";
  }
}
