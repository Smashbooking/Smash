import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smash/authentication/confirm_details.dart';
import 'package:smash/authentication/signup_page.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smash',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(255, 48, 73, 10),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 17, 0)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), //present in pages directory
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer to navigate to the home screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.jpg',
          width: MediaQuery.of(context).size.width, // Responsive width
        ),
      ),
    );
  }
}
