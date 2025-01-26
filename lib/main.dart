import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash/authentication/login.dart';
import 'package:smash/authentication/login_page.dart';
import 'package:smash/authentication/signup_page.dart';
import 'package:smash/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smash',
        theme: AppTheme.lightTheme,
        // theme: ThemeData(
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //       style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.red,
        //           foregroundColor: Colors.white,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10)))),
        //   primaryColor: const Color.fromRGBO(251, 20, 47, 0.965),
        //   scaffoldBackgroundColor: Colors.white,
        //   colorScheme: ColorScheme.fromSeed(
        //       seedColor: const Color.fromARGB(255, 255, 17, 0),
        //       inversePrimary: Colors.black),
        //   useMaterial3: true,
        // ),
        home: const Login());
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
