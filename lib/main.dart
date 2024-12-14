import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smash/admin/profile_page.dart';
import 'package:smash/authentication/login_page.dart';
// import 'package:smash/admin/profile_page.dart';
// import 'package:smash/admin/venue_form.dart';
// import 'package:smash/authentication/confirm_details.dart';

import 'package:smash/authentication/signup_page.dart';
import 'package:smash/screens/home_page.dart';
// import 'package:smash/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Firebase
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
          primaryColor: const Color.fromRGBO(251, 20, 47, 0.965),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 17, 0),
              inversePrimary: Colors.black),
          useMaterial3: true,
        ),
        home: const HomePage());
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
