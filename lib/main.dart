import 'package:flutter/material.dart';
import 'package:leez/screens/user/home/navbar.dart';





void main() {
  runApp(const MyApp());
}






class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leez A Rental Platform',
      home: const NavBar(),
      debugShowCheckedModeBanner: false,
      Theme(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}




















