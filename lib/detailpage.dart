// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/welcome.dart';
import 'package:intl/intl.dart';

class Detailpage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  const Detailpage({
    super.key,
    required this.consolidatedWeatherList,
    required this.selectedId,
    required this.location,
  });

  @override
  State<Detailpage> createState() => _DetailpageState();
}

class _DetailpageState extends State<Detailpage> {
  late int selectedIndex;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedId;
    imageUrl = _getImageUrl(widget.consolidatedWeatherList[selectedIndex]['weather_state_name']);
  }

  String _getImageUrl(String weatherStateName) {
    // Replace spaces with underscores, lowercase to match asset naming convention
    return weatherStateName.replaceAll(' ', '_').toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myconstants = Constants();

    final Shader linearGradient = const LinearGradient(colors: <Color>[
      Color(0xffABCf22),
      Color(0xff9AC6F3),
    ]).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    // Update imageUrl whenever selectedIndex changes
    imageUrl = _getImageUrl(widget.consolidatedWeatherList[selectedIndex]['weather_state_name']);
    var weatherStateName = widget.consolidatedWeatherList[selectedIndex]['weather_state_name'];

    return Scaffold(
      backgroundColor: myconstants.secondarycolor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myconstants.secondarycolor,
        elevation: 0.0,
        title: Text(widget.location),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, MaterialPageRoute(builder: (context) => const Welcome()));
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var futureWeatherName = widget.consolidatedWeatherList[index]['weather_state_name'];
                  var weatherUrl = _getImageUrl(futureWeatherName);
                  var parseDate = DateTime.parse(widget.consolidatedWeatherList[index]['applicable_date']);
                  var newDate = DateFormat('EEEE').format(parseDate).substring(0, 3);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.only(right: 20),
                      width: 80,
                      decoration: BoxDecoration(
                        color: index == selectedIndex ? Colors.white : const Color(0xff9ebcf9),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 5,
                            color: Colors.blue.withOpacity(.3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.consolidatedWeatherList[index]['the_temp'].round()}°C',
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex ? Colors.blue : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset('assets/$weatherUrl.png', width: 40),
                          Text(
                            newDate,
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex ? Colors.blue : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -53,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .3,
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.center,
                          colors: [
                            Color(0xffa9c1f5),
                            Color(0xff6699f5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(.1),
                            offset: const Offset(0, 25),
                            blurRadius: 3,
                            spreadRadius: -10,
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.asset('assets/$imageUrl.png', width: 150),
                          ),
                          Positioned(
                            top: 120,
                            left: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                weatherStateName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  weatherItem(
                                    text: "Windspeed",
                                    value: widget.consolidatedWeatherList[selectedIndex]['Windspeed'].round(),
                                    unit: 'km/hr',
                                    imageUrl: 'assets/Windspeed.png',
                                  ),
                                  weatherItem(
                                    text: "Humidity",
                                    value: widget.consolidatedWeatherList[selectedIndex]['humidity'].round(),
                                    unit: '%',
                                    imageUrl: 'assets/humidity.png',
                                  ),
                                  weatherItem(
                                    text: "Max Temp",
                                    value: widget.consolidatedWeatherList[selectedIndex]['max_temp'].round(),
                                    unit: '°C',
                                    imageUrl: 'assets/Maximum Temperature_.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.consolidatedWeatherList[selectedIndex]['the_temp'].round().toString(),
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = linearGradient,
                                  ),
                                ),
                                Text(
                                  '°',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = linearGradient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 300,
            child: SizedBox(
              height: 200,
              width: size.width * .9,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.consolidatedWeatherList.length,
                itemBuilder: (BuildContext context, int index) {
                  var futureWeatherName = widget.consolidatedWeatherList[index]['weather_state_name'];
                  var futureImageURL = _getImageUrl(futureWeatherName);
                  var parseDate = DateTime.parse(widget.consolidatedWeatherList[index]['applicable_date']);
                  var currentDate = DateFormat('d MMMM, EEEE').format(parseDate);

                  return Container(
                    margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 5),
                    height: 80,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: myconstants.secondarycolor.withOpacity(.1),
                          spreadRadius: 5,
                          blurRadius: 20,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            currentDate,
                            style: const TextStyle(
                              color: Color(0xff6696f5),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.consolidatedWeatherList[index]['max_temp'].round().toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                '/',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 30,
                                ),
                              ),
                              Text(
                                widget.consolidatedWeatherList[index]['min_temp'].round().toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/$futureImageURL.png', width: 30),
                              Text(widget.consolidatedWeatherList[index]['weather_state_name']),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class weatherItem extends StatelessWidget {
  final String text;
  final int value;
  final String unit;
  final String imageUrl;

  const weatherItem({
    Key? key,
    required this.text,
    required this.value,
    required this.unit,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imageUrl, width: 40),
        const SizedBox(height: 5),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}