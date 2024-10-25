// import 'package:flutter/material.dart';
// import 'package:smash/components/my_button.dart';
// import 'package:smash/components/my_textfield.dart';
// import 'package:smash/pages/home_page.dart';

// class ConfirmDetails extends StatefulWidget {
//   const ConfirmDetails({super.key});

//   @override
//   State<ConfirmDetails> createState() => _ConfirmDetailsState();
// }

// class _ConfirmDetailsState extends State<ConfirmDetails> {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   String? selectedGender;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Please confirm the details"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//             Image.asset('assets/images/logo.png'),
//             // First Name Field
//             // const Text(
//             //   "Enter last Name",
//             //   style: TextStyle(
//             //     fontSize: 16,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             // ),
//             MyTextfield(
//               controller: firstNameController,
//               hintText: "First Name",
//               obscureText: false,
//               keyboardType: TextInputType.name,
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//             // Last Name Field
//             // Text(
//             //   "Enter last Name",
//             //   style: TextStyle(
//             //     fontSize: 16,
//             //     fontWeight: FontWeight.bold,
//             //   ),
//             // ),
//             MyTextfield(
//               controller: lastNameController,
//               hintText: "Last Name",
//               obscureText: false,
//               keyboardType: TextInputType.name,
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),

//             MyTextfield(
//               controller: emailController,
//               hintText: "Email",
//               obscureText: false,
//               keyboardType: TextInputType.name,
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//             // Gender Dropdown, aligned with MyTextfield styling
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Gender",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Theme.of(context).colorScheme.tertiary,
//                       ),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: DropdownButtonFormField<String>(
//                       value: selectedGender,
//                       hint: const Text("Select Gender"),
//                       items: <String>["Male", "Female", "Other"]
//                           .map((String gender) {
//                         return DropdownMenuItem<String>(
//                           value: gender,
//                           child: Text(gender),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedGender = newValue;
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         border: InputBorder.none, // Remove default border
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.02,
//                   ),
//                   MyButton(
//                     text: "Proceed",
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HomePage()),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ------------------------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:smash/components/my_button.dart';
import 'package:smash/components/my_textfield.dart';
import 'package:smash/pages/home_page.dart';

class ConfirmDetails extends StatefulWidget {
  const ConfirmDetails({super.key});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Please confirm the details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              Image.asset('assets/images/logo.png'),

              // First Name Field (required)
              MyTextfield(
                controller: firstNameController,
                hintText: "First Name",
                obscureText: false,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "First Name is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Last Name Field (optional)
              MyTextfield(
                controller: lastNameController,
                hintText: "Last Name",
                obscureText: false,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Email Field (optional)
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Gender Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        hint: const Text("Select Gender"),
                        items: <String>["Male", "Female", "Other"]
                            .map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Remove default border
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    MyButton(
                      text: "Proceed",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
