import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/city.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myconstants = Constants();

  // Weather data
  int temperature = 0;
  int maxtemp = 0;
  String weatherStateName = 'Loading...';
  int humidity = 0;
  int windspeed = 0;

  String currentDate = 'Loading...';
  String imageUrl = '';
  String location = 'London';

  var selectedCities = City.getSelectedCities();
  List<String> cities = [''];

  // WeatherAPI configuration
  final String apiKey = '33c0ef9f1e794d5086c165754251409';
  final String baseWeatherUrl = 'https://api.weatherapi.com/v1/current.json';

  final Shader lineargradient = const LinearGradient(
    colors: <Color>[Color(0xffABCf22), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();
    // Add cities from your selectedCities list
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }

    // Fetch weather for default location
    fetchWeather(location);
  }

  void fetchWeather(String cityName) async {
    final url = Uri.parse('$baseWeatherUrl?key=$apiKey&q=$cityName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);

        setState(() {
          temperature = (result['current']['temp_c'] as num).round();
          maxtemp = (result['current']['feelslike_c'] as num).round();
          humidity = (result['current']['humidity'] as num).round();
          windspeed = (result['current']['wind_kph'] as num).round();
          weatherStateName = result['current']['condition']['text'];

          imageUrl = 'https:${result['current']['condition']['icon']}';

          currentDate = DateFormat('EEEE, d MMMM').format(DateTime.now());
        });
      } else {
        print('Error fetching weather. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during fetchWeather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/profile.png', width: 40, height: 40),
              ),
              Row(
                children: [
                  Image.asset('assets/pin.png', width: 4),
                  const SizedBox(width: 4),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: location,
                      icon: const Icon(Icons.arrow_downward_sharp),
                      items: cities.map((String loc) {
                        return DropdownMenuItem<String>(
                          value: loc,
                          child: Text(loc),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            location = newValue;
                            fetchWeather(location);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              location,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              currentDate,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 50),
            Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                color: myconstants.primarycolor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myconstants.primarycolor.withOpacity(.5),
                    offset: const Offset(0, 20),
                    blurRadius: 10,
                    spreadRadius: -15,
                  )
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -40,
                    left: 20,
                    child: imageUrl == ''
                        ? const SizedBox()
                        : Image.network(
                            imageUrl,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherStateName,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            temperature.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = lineargradient,
                            ),
                          ),
                        ),
                        Text(
                          '°',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()..shader = lineargradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weatherItem(
                    text: "Feels Like",
                    value: maxtemp,
                    Unit: '°C',
                    ImageUrl: 'assets/Maximum Temperature_.png',
                  ),
                  weatherItem(
                    text: "Humidity",
                    value: humidity,
                    Unit: '%',
                    ImageUrl: 'assets/humidity.png',
                  ),
                  weatherItem(
                    text: "Wind",
                    value: windspeed,
                    Unit: 'km/h',
                    ImageUrl: 'assets/Windspeed.png',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class weatherItem extends StatelessWidget {
  const weatherItem({
    super.key,
    required this.value,
    required this.text,
    required this.Unit,
    required this.ImageUrl,
  });

  final int value;
  final String text;
  final String Unit;
  final String ImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xffE0E8Fb),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(
            ImageUrl,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        ),
        Text('$value$Unit', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
