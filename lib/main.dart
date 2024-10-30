import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smash/admin/profile_page.dart';
import 'package:smash/authentication/signup_page.dart';
import 'package:smash/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smash',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(251, 20, 47, 0.965),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 17, 0),
            inversePrimary: Colors.black),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
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
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
