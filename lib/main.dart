import 'package:browser/home.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(title: 'Currency Converter',),
    );
  }
}
