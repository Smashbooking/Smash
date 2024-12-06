// -------------------------------------------------------------------------------------------------------
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smash/admin/profile_page.dart';
import 'package:smash/authentication/signup_page.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';
import 'package:smash/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? phoneError;
  bool otpSent = false;
  bool isLoading =
      false; // Track loading state for OTP request and verification

  // Firebase instance references
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? verificationId; // Store verification ID for OTP

  // Function to validate phone number
  bool validatePhoneNumber() {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        phoneError = "Phone number cannot be empty";
      });
      return false;
    } else if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() {
        phoneError = "Enter a valid 10-digit phone number";
      });
      return false;
    }
    setState(() {
      phoneError = null;
    });
    return true;
  }

  // Function to request OTP
  void getOTP() async {
    if (validatePhoneNumber()) {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      try {
        String fullPhoneNumber = '+91${phoneController.text.trim()}';
        await _auth.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            log('Auto-verification completed.');
          },
          verificationFailed: (FirebaseAuthException e) {
            log('Verification failed: ${e.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Verification failed: ${e.message}"),
                backgroundColor: Colors.red,
              ),
            );
          },
          codeSent: (String verId, int? resendToken) {
            setState(() {
              otpSent = true;
              verificationId = verId; // Store the verification ID
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("OTP sent successfully"),
                backgroundColor: Colors.green,
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId; // Store verification ID on timeout
          },
        );
      } catch (e) {
        log('Error requesting OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error requesting OTP: $e"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  // Function to verify OTP and fetch user data

  // -----------------------------------------------------------------------------------------------------
  // void verifyOTP() async {
  //   if (otpController.text.isEmpty || otpController.text.length != 6) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Please enter a valid 6-digit OTP."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     isLoading = true; // Show loading indicator
  //   });

  //   try {
  //     // Use hardcoded test data for verification
  //     const String hardcodedVerificationId =
  //         "+911234567890"; // Replace with your test verification ID
  //     const String hardcodedOTP = "123456"; // Replace with your test OTP

  //     // Use hardcoded values if verificationId is null (for testing)
  //     final String usedVerificationId =
  //         verificationId ?? hardcodedVerificationId;
  //     final String usedOTP = otpController.text.trim();

  //     if (usedVerificationId == hardcodedVerificationId &&
  //         usedOTP != hardcodedOTP) {
  //       throw Exception("Invalid OTP for testing.");
  //     }

  //     // Authenticate using the OTP
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: usedVerificationId,
  //       smsCode: usedOTP,
  //     );
  //     await _auth.signInWithCredential(credential);

  //     // Fetch user data from Firestore
  //     String phoneNumber = _auth.currentUser?.phoneNumber ?? '';
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(phoneNumber).get();

  //     if (userDoc.exists) {
  //       log('User data fetched successfully: ${userDoc.data()}');
  //       if (mounted) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomePage()),
  //         );
  //       }
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Login successful!"),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       log('User data not found.');

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("User not registered. Please sign up."),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     log('Error verifying OTP: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error verifying OTP: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false; // Hide loading indicator
  //     });
  //   }
  // }

  // void verifyOTP() async {
  //   if (otpController.text.isEmpty || otpController.text.length != 6) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Please enter a valid 6-digit OTP."),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   setState(() {
  //     isLoading = true; // Show loading indicator
  //   });

  //   try {
  //     // Authenticate using the OTP
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId!,
  //       smsCode: otpController.text.trim(),
  //     );
  //     await _auth.signInWithCredential(credential);

  //     // Fetch user data from Firestore
  //     String phoneNumber = _auth.currentUser?.phoneNumber ?? '';
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(phoneNumber).get();

  //     if (userDoc.exists) {
  //       // Extract `isAdmin` from Firestore document
  //       bool isAdmin = userDoc.get('isAdmin') ?? false;

  //       log('User data fetched successfully: ${userDoc.data()}');

  //       if (mounted) {
  //         if (isAdmin) {
  //           // Navigate to AdminPage
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => const ProfilePage()),
  //           );
  //         } else {
  //           // Navigate to User HomePage
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(builder: (context) => const HomePage()),
  //           );
  //         }
  //       }

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("Login successful!"),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     } else {
  //       log('User data not found.');

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("User not registered. Please sign up."),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     log('Error verifying OTP: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Error verifying OTP: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false; // Hide loading indicator
  //     });
  //   }
  // }

  void verifyOTP() async {
    if (otpController.text.isEmpty || otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 6-digit OTP."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      // Authenticate using the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );
      await _auth.signInWithCredential(credential);

      // Fetch user data from Firestore
      String phoneNumber = _auth.currentUser?.phoneNumber ?? '';
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(phoneNumber).get();

      if (userDoc.exists) {
        // Extract `isAdmin` from Firestore document
        bool isAdmin = userDoc.get('isAdmin') ?? false;

        log('User data fetched successfully: ${userDoc.data()}');

        if (mounted) {
          if (isAdmin) {
            // Fetch admin data using the helper function
            final adminData = await fetchAdminData(phoneNumber);

            if (adminData != null) {
              // Navigate to VenueForm with admin data
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            } else {
              // Handle case where admin data couldn't be fetched
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Admin data not found."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            // Navigate to User HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        log('User data not found.');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not registered. Please sign up."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log('Error verifying OTP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error verifying OTP: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  // Function to fetch admin data
  Future<Map<String, dynamic>?> fetchAdminData(String phoneNumber) async {
    try {
      // Query Firestore to fetch the document where phoneNumber matches
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .where('isAdmin', isEqualTo: true) // Ensure it's an admin
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      log("Error fetching admin data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: otpSent ? buildOtpInput(context) : buildPhoneInput(context),
      ),
    );
  }

  // Phone number input UI
  Widget buildPhoneInput(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
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
          Text(
            "Please enter a 10-digit valid phone number",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          Text(
            "to get an OTP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          MyTextfield(
            controller: phoneController,
            hintText: "",
            obscureText: false,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          if (phoneError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  phoneError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Text("By proceeding, you agree to the"),
          const Text("Terms and Conditions and Privacy policy "),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          isLoading
              ? const CircularProgressIndicator()
              : MyButton(
                  text: "Get OTP",
                  onTap: getOTP,
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
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text("Sign up!"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // OTP input UI
  Widget buildOtpInput(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: MediaQuery.of(context).size.height * 0.08,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Text(
            "OTP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.04,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "Enter the 6-digit code we sent to ${phoneController.text}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
              controller: otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter OTP",
                counterText: "", // Removes the character counter
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.03,
                letterSpacing: 8.0,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GestureDetector(
            onTap: () {
              // Placeholder for resend OTP logic
            },
            child: Text(
              "Resend code",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          isLoading
              ? const CircularProgressIndicator()
              : MyButton(
                  text: "Verify OTP",
                  onTap: verifyOTP,
                ),
        ],
      ),
    );
  }
}
