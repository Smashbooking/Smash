import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  String? phoneError; // Error message for phone number
  bool otpSent = false; // Track if OTP was sent

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

  // Function to handle OTP submission
  void getOTP() {
    if (validatePhoneNumber()) {
      // Placeholder for logic to request OTP.
      // You will add the actual OTP request logic here.
      setState(() {
        otpSent = true;
      });
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
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill)),
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

          // Phone number input using MyTextfield
          MyTextfield(
            controller: phoneController,
            hintText: "",
            obscureText: false,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),

          // Error message
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
          // SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          const Text("Terms and Conditions and Privacy policy "),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          // Get OTP Button
          MyButton(
            text: "Get OTP",
            onTap: getOTP, // Calls the OTP function
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      ),
    );
  }

  // OTP input UI
  Widget buildOtpInput(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // OTP Icon
        Icon(
          Icons.lock_outline,
          size: MediaQuery.of(context).size.height * 0.08,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),

        // OTP Text
        Text(
          "OTP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.04,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        // Instructional Text
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

        // OTP Input Fields (6 boxes)
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

        // Resend Code
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

        SizedBox(height: MediaQuery.of(context).size.height * 0.1),

        // Verify OTP Button
        MyButton(
          text: "Verify OTP",
          onTap: () {
            // Navigator.push(context, route)
            // Placeholder for OTP verification logic
          },
        ),
      ],
    );
  }
}
