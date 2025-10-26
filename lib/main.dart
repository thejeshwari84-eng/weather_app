import 'package:flutter/material.dart';
import 'package:flutter_application_1/getstarted.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(  
       primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
),
       home: const Getstarted(),

    );
  }
}