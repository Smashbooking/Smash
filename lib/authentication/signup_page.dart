import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Function to handle OTP request and show bottom sheet
  void getOTP() {
    if (validatePhoneNumber()) {
      showOtpBottomSheet(context); // Show the OTP bottom sheet
    }
  }

  // Show OTP Bottom Sheet
  void showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white.withOpacity(0.9), // Partially transparent
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return OTPBottomSheet(
          phoneNumber: phoneController.text,
          otpControllers: otpControllers,
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
            decoration: BoxDecoration(
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
          // Text(
          //   "to get an OTP",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: MediaQuery.of(context).size.height * 0.02,
          //   ),
          // ),
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
          MyButton(
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

// OTP Bottom Sheet Content
class OTPBottomSheet extends StatelessWidget {
  final String phoneNumber;
  final List<TextEditingController> otpControllers;

  const OTPBottomSheet({
    Key? key,
    required this.phoneNumber,
    required this.otpControllers,
  }) : super(key: key);

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
                icon: Icon(Icons.cancel),
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
              "Enter the 6-digit code we sent to $phoneNumber",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: MyTextfield(
                  controller: otpControllers[index],
                  hintText: "",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              );
            }),
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
          MyButton(
            text: "Verify OTP",
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ConfirmDetails()));
              // Placeholder for OTP verification logic
            },
          ),
        ],
      ),
    );
  }
}


// // // ---------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
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

//   String? phoneError; // Error message for phone number
//   bool otpSent = false; // Track if OTP was sent

//   // Function to validate phone number
//   bool validatePhoneNumber() {
//     String phone = phoneController.text.trim();
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

//   // Function to handle OTP submission
//   void getOTP() {
//     if (validatePhoneNumber()) {
//       // Placeholder for logic to request OTP.
//       // You will add the actual OTP request logic here.
//       setState(() {
//         otpSent = true;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: otpSent ? buildOtpInput(context) : buildPhoneInput(context),
//       ),
//     );
//   }

//   // Phone number input UI
//   Widget buildPhoneInput(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.05,
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.2,
//             width: MediaQuery.of(context).size.width * 0.4,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                     image: AssetImage('assets/images/logo.png'),
//                     fit: BoxFit.fill)),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.05),

//           Text(
//             "Please enter a 10-digit valid phone number",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: MediaQuery.of(context).size.height * 0.02,
//             ),
//           ),
//           Text(
//             "to get an OTP",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: MediaQuery.of(context).size.height * 0.02,
//             ),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//           // Phone number input using MyTextfield
//           MyTextfield(
//             controller: phoneController,
//             hintText: "",
//             obscureText: false,
//             keyboardType: TextInputType.phone,
//             inputFormatters: <TextInputFormatter>[
//               FilteringTextInputFormatter.digitsOnly,
//             ],
//           ),

//           // Error message
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
//           // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//           const Text("Terms and Conditions and Privacy policy "),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.03),

//           // Get OTP Button
//           MyButton(
//             text: "Get OTP",
//             onTap: getOTP, // Calls the OTP function
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
//           )
//         ],
//       ),
//     );
//   }

//   // OTP input UI
//   Widget buildOtpInput(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // OTP Icon
//         Icon(
//           Icons.lock_outline,
//           size: MediaQuery.of(context).size.height * 0.08,
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.05),

//         // OTP Text
//         Text(
//           "OTP",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: MediaQuery.of(context).size.height * 0.04,
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//         // Instructional Text
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25),
//           child: Text(
//             "Enter the 6-digit code we sent to ${phoneController.text}",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height * 0.02,
//               color: Colors.grey,
//             ),
//           ),
//         ),

//         SizedBox(height: MediaQuery.of(context).size.height * 0.03),

//         // OTP Input Fields (6 boxes)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(6, (index) {
//             return SizedBox(
//               width: MediaQuery.of(context).size.width * 0.12,
//               child: MyTextfield(
//                 controller: otpControllers[index],
//                 hintText: "",
//                 obscureText: false,
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(1),
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//             );
//           }),
//         ),

//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),

//         // Resend Code
//         GestureDetector(
//           onTap: () {
//             // Placeholder for resend OTP logic
//           },
//           child: Text(
//             "Resend code",
//             style: TextStyle(
//               fontSize: MediaQuery.of(context).size.height * 0.02,
//               color: Theme.of(context).colorScheme.primary,
//             ),
//           ),
//         ),

//         SizedBox(height: MediaQuery.of(context).size.height * 0.1),

//         // Verify OTP Button
//         MyButton(
//           text: "Verify OTP",
//           onTap: () {
//             // Navigator.push(context, route)
//             // Placeholder for OTP verification logic
//           },
//         ),
//       ],
//     );
//   }
// }
