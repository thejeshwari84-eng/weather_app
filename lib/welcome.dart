// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/city.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
 
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  List<City> cities = City.citiesList.where((City) => City.isdefault== false).toList();
  List<City> selectedCities = City.getSelectedCities();
  
    @override
  Widget build(BuildContext context) {
    Constants myconstants = Constants();
      
  Size size = MediaQuery.of(context).size;
  
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myconstants.secondarycolor,
        // ignore: prefer_interpolation_to_compose_strings
        title: Text('${selectedCities.length} selected'),

        ),
        body: ListView.builder(
          itemCount: cities.length, 
          itemBuilder: (BuildContext context, int index){
          return Container(
            margin: const EdgeInsets.only(left:10, top:20, right:10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 80,
            width: size.width,
            decoration: BoxDecoration(
              border: cities[index].isSelected ==true? Border.all(
                // ignore: deprecated_member_use
                color: myconstants.secondarycolor.withOpacity(.6),
                width: 2,
              ) : Border.all(color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use 
                  color: myconstants.primarycolor.withOpacity(.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 2),


                )
              ]
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cities[index].isSelected = !cities[index].isSelected;

                    });
                  
                  },
                  child: Image.asset(cities[index].isSelected == true? 'assets/Checked.png': 'assets/Unchecked.png', width: 30)),
                const SizedBox(width: 10),
                Text(cities[index].city, style: TextStyle(
                  fontSize: 16,
                  color: cities[index].isSelected==true? myconstants.primarycolor: Colors.black
                ),),
              ],
            ),
          );
          },
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: myconstants.secondarycolor,
          child: const Icon(Icons.pin_drop),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
          },
        ), );
  }
}