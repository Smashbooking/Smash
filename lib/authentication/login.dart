// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:smash/components/my_button.dart';
// import 'package:smash/components/my_textfield.dart';
// import 'package:smash/screens/home_page.dart';

// import 'sign.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<Login> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool isLoading = false; // Loading indicator for login actions

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Login with email and password
//   Future<void> login() async {
//     setState(() => isLoading = true);
//     try {
//       final email = emailController.text.trim();
//       final password = passwordController.text.trim();

//       // Authenticate user
//       final UserCredential userCredential =
//           await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Fetch user data from Firestore
//       final userDoc = await _firestore
//           .collection('users')
//           .doc(userCredential.user?.uid)
//           .get();

//       if (userDoc.exists) {
//         log('User logged in successfully: ${userDoc.data()}');
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomePage()),
//           );
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Login successful!"),
//               backgroundColor: Colors.green),
//         );
//       } else {
//         log('User data not found in Firestore.');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("User not registered. Please sign up."),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       log("Login failed: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text("Login failed: $e"), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.2,
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   image: DecorationImage(
//                     image: AssetImage('assets/images/logo.png'),
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               const Text("Please log in using your email and password."),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//               MyTextfield(
//                 controller: emailController,
//                 hintText: "Email",
//                 obscureText: false,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//               MyTextfield(
//                 keyboardType: TextInputType.text,
//                 controller: passwordController,
//                 hintText: "Password",
//                 obscureText: true,
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//               isLoading
//                   ? const CircularProgressIndicator()
//                   : MyButton(
//                       text: "Login",
//                       onTap: login,
//                     ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Don't have an account?"),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const Sign()),
//                       );
//                     },
//                     child: const Text("Sign up!"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';
import 'package:smash/screens/home_page.dart';

import '../providers/auth_provider.dart';
import 'sign.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    await ref.read(authNotifierProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the auth state
    final authState = ref.watch(authNotifierProvider);

    // Handle navigation and error messages
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }

      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const Text("Please log in using your email and password."),
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
              authState.isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      text: "Login",
                      onTap: login,
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Sign(),
                        ),
                      );
                    },
                    child: const Text("Sign up!"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
