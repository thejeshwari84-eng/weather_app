// ignore: unnecessary_import
// ignore_for_file: deprecated_member_use

// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/welcome.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {

    Constants myconstants = Constants();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: myconstants.primarycolor.withOpacity(.5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/weather .png'),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context)=> const Welcome()));
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    color: myconstants.primarycolor,
                    borderRadius: BorderRadius.all(Radius.circular(10)), ), 
                            child: const Center(
                              child: Text("Get started", style: TextStyle(color: Colors.white, fontSize: 20,),
                              
                            ),
                          ),
              ),
              ),
                      
            ],
                    ),
                  ),
                ),
    );
  }
}