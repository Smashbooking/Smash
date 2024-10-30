import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;

  Future<void> _changeProfilePicture() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImagePath = pickedFile.path;
        });
        _showSnackBar("Profile picture updated successfully!", Colors.green);
      } else {
        _showSnackBar("No image selected.", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Failed to pick image: $e", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gradient Background and Profile Picture
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.redAccent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImagePath != null
                            ? Image.file(File(_profileImagePath!)).image
                            : const AssetImage('assets/images/profile.jpg'),
                      ),
                      TextButton(
                        onPressed: _changeProfilePicture,
                        child: const Text(
                          'Change Picture',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // Form fields for Username, Email ID, Phone Number, and Location
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Username',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: _inputBorder(Colors.black),
                      focusedBorder:
                          _inputBorder(Theme.of(context).primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Email ID',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: _inputBorder(Colors.black),
                      focusedBorder:
                          _inputBorder(Theme.of(context).primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Phone Number',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      enabledBorder: _inputBorder(Colors.black),
                      focusedBorder:
                          _inputBorder(Theme.of(context).primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Location',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      enabledBorder: _inputBorder(Colors.black),
                      focusedBorder:
                          _inputBorder(Theme.of(context).primaryColor),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Update Profile Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showSnackBar(
                            "Profile updated successfully!", Colors.green);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                      ),
                      child: const Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
