import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/city.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/detailpage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Constants myconstants = Constants();

  //initialization
  int temperature = 0;
  int maxtemp = 0;
  // ignore: non_constant_identifier_names
  String WeatherStateName = 'Loading...';
  int humidity = 0;
  int windspeed =0;

  var currentDate = 'Loading...';
  String imageUrl = '';
  int woied = 44418;
  String location = 'London';

  var selectedCities = City.getSelectedCities();
  List<String>cities = ['London'];
  List consolidateWeatherList = [];

  //api calls Url

  String searchLocationUrl =  'https://www.metaweather.com/api/location/search/?query=';
//to get the woeid
  String searchWeatherUrl ='https://www.metaweather.com/api/location/';



  //get the where on earth id 
  // ignore: non_constant_identifier_names
 void fetchLocation(String location) async {
  var searchResult = await http.get(Uri.parse(searchLocationUrl + location));
  var result = json.decode(searchResult.body);

  if (result.isNotEmpty) {
    setState(() {
      woied = result[0]['woeid'];
    });

    fetchWeatherData();
  }
}


  void fetchWeatherData() async{
  var weatherResult =  await http.get(Uri.parse(searchWeatherUrl + woied.toString()));

  var result = json.decode(weatherResult.body);
  var consolidateWeather = result['consolidated_weather'];

  

  setState(() {
    for(int i = 0; i<7; i++){
      consolidateWeather.add(consolidateWeather[i]); // this takes the consolidate weather for next six days for location searched
    }
  });
    //the index 0 refers to first entry which is current day. The next day will be index 1, the second day will be 2
  temperature = consolidateWeather[0]['the_temp'].round(); 
  WeatherStateName = consolidateWeather[0]['weather_state_name'];
  humidity = consolidateWeather[0]['humidity'].round();
  windspeed = consolidateWeather[0]['wind_speed'].round();
  maxtemp = consolidateWeather[0]['max_temp'].round();

  //date formatting
  // ignore: unused_local_variable
 var date = DateTime.parse(consolidateWeather[0]['applicable_date']);
 currentDate = DateFormat('EEEE, d MMMM').format(date);
 
  
  //set the image Url
 imageUrl = WeatherStateName.replaceAll(' ', '').toLowerCase();

//remove any spaces in the weather state name
  //and change to lower case because that is how we have named the images

  consolidateWeatherList = List.from(consolidateWeather);
 

  }

@override
void initState() {
  super.initState();

  for (int i = 0; i < selectedCities.length; i++) {
    cities.add(selectedCities[i].city);
  }

  fetchLocation(cities[0]);
}


  //create a shader linear gradient

  final Shader lineargradient = const LinearGradient(colors: <Color>[
   Color(0xffABCf22), Color(0xff9AC6F3)

  ], ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  
  get selectedDay => null;
  
  DateTime? get myDate => null;
  



  @override
  Widget build(BuildContext context,  ) {

    Size size= MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset('assets/profile.png',
                width: 40,
                height: 40,
                  
                ),
                
              ),
              Row(
          
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/pin.png', width: 4,),
                    const SizedBox(width: 4),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: location,
                        icon: const Icon(Icons.arrow_downward_sharp),
                        items: cities.map((String location) {
                        return DropdownMenuItem(
                          value: location,
                         child: Text(location),
                          );
                        }).toList(),
                        onChanged: (String?newvalue){
                          setState(() {
                            location = newvalue!;
                            fetchLocation(location);
                            fetchWeatherData();
                          });
                        }
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
        Text(location, style:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30.0,
        ) ,),
         Text(currentDate, style:TextStyle(
         color: Colors.grey,
          fontSize: 16.0,
        ) ,),
        const SizedBox(
          height: 50,
        ),
        Container(
          width: size.width,
          height:200,
          decoration: BoxDecoration(
            color: myconstants.primarycolor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: myconstants.primarycolor.withOpacity(.5),
                offset: const Offset(0, 20),
                blurRadius: 10,
                spreadRadius: -15,

              )
            ]

          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
            Positioned(
              top: -40,
              left: 20,
              // ignore: prefer_interpolation_to_compose_strings
              child: imageUrl==''? const Text(''):Image.asset('assets/' + imageUrl + '.png', width: 150)
                       ),
              Positioned(
                bottom: 30,
                left: 20,
                child: 
              Text(WeatherStateName, style: TextStyle(color: Colors.white,
              fontSize: 20),)),
              Positioned(
                top:20,
                right:20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 40),
                    child: Text(temperature.toString(), style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader=lineargradient,
                    ),),), 
                    Text('o', style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..shader=lineargradient,
                    ),
                    )
                  ],
                )), 
            ],
          ),
        ),
      const SizedBox(height: 50),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         weatherItem(text: "windspeed",value: windspeed, Unit: 'km/hr', ImageUrl: 'assets/Windspeed.png',),
         weatherItem(text: "Humidity",value: humidity, Unit: '', ImageUrl: 'assets/humidity.png',),
         weatherItem(text: "windspeed",value: maxtemp, Unit: 'C', ImageUrl: 'assets/Maximum Temperature_.png',),

            ],
          ),
          
      ),
    const SizedBox(
      height: 50,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Today', style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize:24 ,
          color: myconstants.primarycolor,

        ),),
        Text('n')
      ],    ),
      const SizedBox(
        height: 20),
        Expanded(child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: consolidateWeatherList.length,
          itemBuilder: (BuildContext context, int index ){
            String today = DateTime.now().toString().substring(0,10);
            // ignore: unused_local_variable
            var selectedDate = consolidateWeatherList[index]['applicable_date'];
            var futureWeatherName = consolidateWeatherList[index]['weather_state_name'];

            var weatherUrl = futureWeatherName.replaceAll('', '').toLowerCase();

            var parseDate = DateTime.parse(consolidateWeatherList[index]['applicable_date']);
            // ignore: unused_local_variable
            var newDate= DateFormat('EEEE').format(parseDate).substring(0,3);

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Detailpage(consolidatedWeatherList: consolidateWeatherList,selectedId: index, location: location,)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                margin: EdgeInsets.only(right: 20, bottom: 10, top: 10),
                width: 80,
                decoration: BoxDecoration(
                  color: selectedDay == today  ? myconstants.primarycolor:Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 5,
                      // ignore: deprecated_member_use
                      color: selectedDay== today? myconstants.primarycolor: Colors.black45.withOpacity(.5),
                      
                    )
                  ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  // ignore: prefer_interpolation_to_compose_strings
                  Text(consolidateWeatherList[index]['the_temp'].round().toString()+ "C",
                  style: TextStyle(
                    fontSize: 17,
                    color: selectedDay == today? Colors.white: myconstants.primarycolor,
                    fontWeight: FontWeight.w500,
              
                  ),),
                  // ignore: prefer_interpolation_to_compose_strings
               Image.asset('assets/' + weatherUrl + '.png', width: 30),

                 Text(newDate, style: TextStyle(

                    fontSize: 17,
                    color: selectedDay == today? Colors.white: myconstants.primarycolor,
                    fontWeight: FontWeight.w500,
                  ), ),
                 
                  ],
                ),
                
              ),
            );
          }
        ))

        ],
        
      ),
      
      ),
  );}
}

// ignore: camel_case_types
class weatherItem extends StatelessWidget {
  const weatherItem({
    super.key,
    // ignore: non_constant_identifier_names
    required this.value, required this.text, required this.Unit, required this.ImageUrl,
  });

  final int value;
  final String text;
  // ignore: non_constant_identifier_names
  final String Unit;
  // ignore: non_constant_identifier_names
  final String ImageUrl;


  @override
  Widget build(BuildContext context) {
    return Column(
         children: [
            Text(text, style: const TextStyle(
             color: Colors.black54
       
           )),
           const SizedBox(
             height: 8,
           ),
           Container(
           padding:
           const EdgeInsets.all(20.0),
           height:60,
           width:60,
           decoration: BoxDecoration(
             color: Color(0xffE0E8Fb),
             borderRadius: BorderRadiusDirectional.circular(15),
           ),
           child: Image.asset('assets/Windspeed.png'),
       
           ),
           // ignore: prefer_interpolation_to_compose_strings
           Text(value.toString()+ Unit, style: const TextStyle(
             fontWeight: FontWeight.bold,
       
           ),),
         ],
       
           );
  }
}