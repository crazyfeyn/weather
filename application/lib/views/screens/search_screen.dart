import 'package:application/services/weather_services_http.dart';
import 'package:application/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  WeatherServices weatherController = WeatherServices();
  TextEditingController searchController = TextEditingController();
  String? searchError;
  bool searchCheck = true;
  List<String> savedCities = [];

  Future<void> saveString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> existingCities = await getString();
    existingCities.add(searchController.text);
    prefs.setStringList('savedCities', existingCities);

    setState(() {
      savedCities = existingCities;
    });
  }

  void deleteCity(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> existingCities = await getString();
    existingCities.removeAt(existingCities.length - index - 1);
    prefs.setStringList('savedCities', existingCities);

    setState(() {
      savedCities = existingCities;
    });
  }

  Future<List<String>> getString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? box = prefs.getStringList('savedCities');
    if (box == null) {
      return [];
    } else {
      return box;
    }
  }

  void firstFunc() async {
    savedCities = await getString();
    setState(() {});
  }

  void toReversedList() {
    setState(() {
      savedCities = savedCities.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    firstFunc();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    toReversedList();
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
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      onSubmitted: (value) {
                        aa();
                      },
                      controller: searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        label: const Text(
                          "Search for cities",
                          style: TextStyle(color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        suffixIcon: searchCheck
                            ? IconButton(
                                onPressed: aa,
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ))
                            : SizedBox(
                                width: 10,
                                child: Image.asset("assets/images/load.gif"),
                              ),
                        errorText: searchError,
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: savedCities.length,
                          itemBuilder: (context, index) {
                            final city = savedCities[index];
                            if (city.isNotEmpty)
                              // ignore: curly_braces_in_flow_control_structures
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(latLung: city),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                    savedCities[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.h,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        deleteCity(index);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.xmark,
                                        color: Colors.white,
                                        size: 16.h,
                                      )),
                                ),
                              );
                            return null;
                          }))
                ],
              ))),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 178, 123, 189),
        padding: EdgeInsets.only(bottom: 30.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 50,
                )),
            SizedBox(
              width: 20.w,
            )
          ],
        ),
      ),
    );
  }

  void aa() async {
    setState(() {
      searchCheck = false;
    });
    final box = await weatherController.getInfotmation(searchController.text);
    if (box is String) {
      searchError = box;
      setState(() {
        searchCheck = true;
      });
    } else {
      searchCheck = true;
      await saveString();

      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(latLung: searchController.text),
          ));
    }
  }
}
