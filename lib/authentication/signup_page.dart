// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:smash/authentication/confirm_details.dart';
// import 'package:smash/components/my_button.dart';
// import 'package:smash/components/my_textfield.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final TextEditingController phoneController = TextEditingController();
//   final List<TextEditingController> otpControllers =
//       List.generate(6, (index) => TextEditingController());

//   String? phoneError;

//   // Function to validate phone number
//   bool validatePhoneNumber() {
//     String phone = phoneController.text.trim();

//     // Ensure phone number is exactly 10 digits
//     if (phone.isEmpty) {
//       setState(() {
//         phoneError = "Phone number cannot be empty";
//       });
//       return false;
//     } else if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
//       setState(() {
//         phoneError = "Enter a valid 10-digit phone number";
//       });
//       return false;
//     }

//     setState(() {
//       phoneError = null;
//     });
//     return true;
//   }

//   // Function to handle OTP request and show bottom sheet
//   void getOTP() async {
//     if (validatePhoneNumber()) {
//       // Append +91 to the entered phone number
//       String fullPhoneNumber = '+91${phoneController.text.trim()}';

//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: fullPhoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) {
//           log('Auto-verification completed.');
//         },
//         verificationFailed: (FirebaseAuthException ex) {
//           log('Verification failed: ${ex.message}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Verification failed: ${ex.message}"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           log('Code sent. Verification ID: $verificationId');

//           // Show green snackbar when OTP is successfully sent
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text("OTP sent successfully"),
//               backgroundColor: Colors.green,
//             ),
//           );

//           // Show the OTP bottom sheet
//           showOtpBottomSheet(context, verificationId);
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           log('Code auto-retrieval timeout. Verification ID: $verificationId');
//         },
//       );
//     }
//   }

//   // Show OTP Bottom Sheet
//   void showOtpBottomSheet(BuildContext context, String verificationId) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white.withOpacity(0.9), // Partially transparent
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return OTPBottomSheet(
//           verificationId: verificationId,
//           phoneNumber: phoneController.text,
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Sign Up"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: buildPhoneInput(context),
//       ),
//     );
//   }

//   // Phone input UI
//   Widget buildPhoneInput(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.2,
//             width: MediaQuery.of(context).size.width * 0.4,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 image: AssetImage('assets/images/logo.png'),
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//           Text(
//             "Enter valid phone number",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: MediaQuery.of(context).size.height * 0.02,
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           MyTextfield(
//             controller: phoneController,
//             hintText: "Enter your 10-digit phone number",
//             obscureText: false,
//             keyboardType: TextInputType.phone,
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
//             ],
//           ),
//           if (phoneError != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   phoneError!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           const Text("By proceeding, you agree to the"),
//           const Text("Terms and Conditions and Privacy policy "),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           MyButton(
//             text: "Get OTP",
//             onTap: getOTP,
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           const Divider(),
//           const Text("Sign in with other options"),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Image.network(
//                   'https://img.icons8.com/color/48/google-logo.png',
//                 ),
//                 Image.network(
//                   'https://img.icons8.com/ios-filled/50/mac-os.png',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // OTP Bottom Sheet
// class OTPBottomSheet extends StatefulWidget {
//   final String verificationId;
//   final String phoneNumber;

//   OTPBottomSheet({
//     Key? key,
//     required this.phoneNumber,
//     required this.verificationId,
//   }) : super(key: key);

//   @override
//   State<OTPBottomSheet> createState() => _OTPBottomSheetState();
// }

// class _OTPBottomSheetState extends State<OTPBottomSheet> {
//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.cancel),
//                 onPressed: () =>
//                     Navigator.pop(context), // Close the bottom sheet
//               ),
//             ],
//           ),
//           Icon(
//             Icons.lock_outline,
//             size: MediaQuery.of(context).size.height * 0.08,
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           Text(
//             "OTP",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: MediaQuery.of(context).size.height * 0.04,
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Text(
//               "Enter the 6-digit code we sent to +91${widget.phoneNumber}",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.height * 0.02,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 50),
//             child: TextField(
//               controller: otpController,
//               maxLength: 6,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(6),
//                 FilteringTextInputFormatter.digitsOnly,
//               ],
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: "Enter OTP",
//                 counterText: "", // Removes the character counter
//               ),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.height * 0.03,
//                 letterSpacing: 8.0,
//               ),
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//           GestureDetector(
//             onTap: () {
//               // Placeholder for resend OTP logic
//             },
//             child: Text(
//               "Resend code",
//               style: TextStyle(
//                 fontSize: MediaQuery.of(context).size.height * 0.02,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                   verificationId: widget.verificationId,
//                   smsCode: otpController.text.trim(),
//                 );
//                 await FirebaseAuth.instance.signInWithCredential(credential);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ConfirmDetails()),
//                 );
//               } catch (ex) {
//                 log('Error verifying OTP: $ex');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text("Invalid OTP. Please try again."),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             },
//             child: const Text("Verify OTP"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     otpController.dispose();
//     super.dispose();
//   }
// }

// ---------------------------------------------------------------------------------------------------------------
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smash/authentication/confirm_details.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  String? phoneError;
  bool isLoading = false; // To track the loading state

  // Function to validate phone number
  bool validatePhoneNumber() {
    String phone = phoneController.text.trim();

    // Ensure phone number is exactly 10 digits
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

  // Function to handle OTP request and show bottom sheet
  void getOTP() async {
    if (validatePhoneNumber()) {
      setState(() {
        isLoading = true; // Start loading
      });

      try {
        // Append +91 to the entered phone number
        String fullPhoneNumber = '+91${phoneController.text.trim()}';

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: fullPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {
            log('Auto-verification completed.');
          },
          verificationFailed: (FirebaseAuthException ex) {
            log('Verification failed: ${ex.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Verification failed: ${ex.message}"),
                backgroundColor: Colors.red,
              ),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            log('Code sent. Verification ID: $verificationId');

            // Show green snackbar when OTP is successfully sent
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("OTP sent successfully"),
                backgroundColor: Colors.green,
              ),
            );

            // Show the OTP bottom sheet
            showOtpBottomSheet(context, verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log('Code auto-retrieval timeout. Verification ID: $verificationId');
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
          isLoading = false; // Stop loading
        });
      }
    }
  }

  // Show OTP Bottom Sheet
  void showOtpBottomSheet(BuildContext context, String verificationId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9), // Partially transparent
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return OTPBottomSheet(
          verificationId: verificationId,
          phoneNumber: phoneController.text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: buildPhoneInput(context),
      ),
    );
  }

  // Phone input UI
  Widget buildPhoneInput(BuildContext context) {
    return SingleChildScrollView(
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
          Text(
            "Enter valid phone number",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          MyTextfield(
            controller: phoneController,
            hintText: "Enter your 10-digit phone number",
            obscureText: false,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
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
          const Divider(),
          const Text("Sign in with other options"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.network(
                  'https://img.icons8.com/color/48/google-logo.png',
                ),
                Image.network(
                  'https://img.icons8.com/ios-filled/50/mac-os.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// OTP Bottom Sheet
class OTPBottomSheet extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPBottomSheet({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OTPBottomSheet> createState() => _OTPBottomSheetState();
}

class _OTPBottomSheetState extends State<OTPBottomSheet> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () =>
                    Navigator.pop(context), // Close the bottom sheet
              ),
            ],
          ),
          Icon(
            Icons.lock_outline,
            size: MediaQuery.of(context).size.height * 0.08,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
              "Enter the 6-digit code we sent to +91${widget.phoneNumber}",
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
          ElevatedButton(
            onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: otpController.text.trim(),
                );
                await FirebaseAuth.instance.signInWithCredential(credential);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConfirmDetails()),
                );
              } catch (ex) {
                log('Error verifying OTP: $ex');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Invalid OTP. Please try again."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Verify OTP"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}