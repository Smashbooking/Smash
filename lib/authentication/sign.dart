import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';

import '../screens/home_page.dart';

class Sign extends StatefulWidget {
  const Sign({super.key});

  @override
  State<Sign> createState() => _SignupPageState();
}

class _SignupPageState extends State<Sign> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false; // Loading indicator for signup actions

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create user with email and password
  Future<void> signup() async {
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final phoneNumber = phoneController.text.trim();

      // Create Firebase user
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        "email": email,
        "phoneNumber": phoneNumber,
        "isAdmin": false, // Default value
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Colors.green),
      );

      if (mounted) {
        // Navigator.pop(context); // Go back to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      log("Signup failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Signup failed: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text("Create a new account."),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              MyTextfield(
                keyboardType: TextInputType.text,
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              MyTextfield(
                controller: phoneController,
                hintText: "Phone Number",
                obscureText: false,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      text: "Sign Up",
                      onTap: signup,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
