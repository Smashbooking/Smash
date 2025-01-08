import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smash/admin/profile_page.dart';

class VenueForm extends StatefulWidget {
  final String adminPhoneNumber; // Admin's phone number
  const VenueForm({super.key, required this.adminPhoneNumber});

  @override
  _VenueFormState createState() => _VenueFormState();
}

class _VenueFormState extends State<VenueForm> {
  final _formKey = GlobalKey<FormState>();
  final _venueNameController = TextEditingController();
  final _venueAddressController = TextEditingController();
  final _venueDescriptionController = TextEditingController();
  final _venueLocationController = TextEditingController();
  final _venueContactController = TextEditingController();
  final _venueHoursController = TextEditingController();
  final _venuePriceController = TextEditingController();

  File? _displayPicture;
  List<File> _referencePictures = [];
  final Color primaryColor = const Color.fromRGBO(251, 20, 47, 0.965);

  bool _isLoading = false;

  // Method to pick image
  Future<void> _pickImage(ImageSource source, bool isDisplayPicture) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          if (isDisplayPicture) {
            _displayPicture = File(pickedFile.path);
          } else {
            _referencePictures.add(File(pickedFile.path));
          }
        });
      }
    } catch (error) {
      _showSnackbar('Failed to pick image: $error', Colors.red);
    }
  }

  // Commented-out Firebase Storage image upload logic
  /*
  Future<String> _uploadImage(File image, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  */

  // Save venue data to Firestore without image URLs
  Future<void> _saveVenue() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackbar('Please fill out all fields.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare Firestore data (no image uploads)
      final venueData = {
        'venue_name': _venueNameController.text,
        'address': _venueAddressController.text,
        'description': _venueDescriptionController.text,
        'location': _venueLocationController.text,
        'contact': _venueContactController.text,
        'hours': _venueHoursController.text,
        'price': int.parse(_venuePriceController.text),
        'admin_phone': widget.adminPhoneNumber, // Store admin phone number
        'created_at': Timestamp.now(),
      };

      await FirebaseFirestore.instance.collection('venues').add(venueData);

      _showSnackbar('Venue saved successfully!', Colors.green);
      // Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProfilePage())); // Navigate back or to a success page
    } catch (e) {
      _showSnackbar('Failed to save venue: $e', Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Form'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoading) const LinearProgressIndicator(),
                const SizedBox(height: 16.0),

                // Upload Display Picture button and preview image
                Center(
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery, true),
                    child: _displayPicture == null
                        ? Icon(
                            Icons.add_circle,
                            color: primaryColor,
                            size: 50,
                          )
                        : Container(
                            padding: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(_displayPicture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Upload Reference Photos button
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery, false),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Add Reference Photo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Display reference photos preview
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _referencePictures.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _referencePictures[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),

                // Text Fields
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                          maxLines: 1,
                          controller: _venueNameController,
                          labelText: 'Venue Name'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: _buildTextField(
                          maxLines: 1,
                          controller: _venueLocationController,
                          labelText: 'Location'),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        SizedBox(
                          width: 100,
                          child: _buildTextField(
                              maxLines: 1,
                              controller: _venuePriceController,
                              labelText: 'Price',
                              keyboardType: TextInputType.number),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildTextField(
                    maxLines: 2,
                    controller: _venueAddressController,
                    labelText: 'Venue Address'),
                _buildTextField(
                    maxLines: 2,
                    controller: _venueDescriptionController,
                    labelText: 'Description'),
                _buildTextField(
                    maxLines: 1,
                    controller: _venueContactController,
                    labelText: 'Contact',
                    keyboardType: TextInputType.phone),
                _buildTextField(
                    maxLines: 1,
                    controller: _venueHoursController,
                    labelText: 'Hours'),

                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveVenue,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required int maxLines,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}

// --------------------------------------------------------------------------------------------------------------------------------
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:smash/admin/profile_page.dart';

// class VenueForm extends StatefulWidget {
//   final String adminPhoneNumber; // Admin's phone number
//   const VenueForm({Key? key, required this.adminPhoneNumber}) : super(key: key);

//   @override
//   _VenueFormState createState() => _VenueFormState();
// }

// class _VenueFormState extends State<VenueForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _venueNameController = TextEditingController();
//   final _venueAddressController = TextEditingController();
//   final _venueDescriptionController = TextEditingController();
//   final _venueLocationController = TextEditingController();
//   final _venueContactController = TextEditingController();
//   final _venueHoursController = TextEditingController();
//   final _venuePriceController = TextEditingController();

//   File? _displayPicture;
//   List<File> _referencePictures = [];
//   final Color primaryColor = const Color.fromRGBO(251, 20, 47, 0.965);

//   bool _isLoading = false;

//   // Method to pick image
//   Future<void> _pickImage(ImageSource source, bool isDisplayPicture) async {
//     try {
//       final pickedFile = await ImagePicker().pickImage(source: source);
//       if (pickedFile != null) {
//         setState(() {
//           if (isDisplayPicture) {
//             _displayPicture = File(pickedFile.path);
//           } else {
//             _referencePictures.add(File(pickedFile.path));
//           }
//         });
//       }
//     } catch (error) {
//       _showSnackbar('Failed to pick image: $error', Colors.red);
//     }
//   }

//   // Method to upload image to Firebase Storage
//   Future<String> _uploadImage(File image, String path) async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child(path);
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       throw Exception('Failed to upload image: $e');
//     }
//   }

//   // Method to save venue data to Firestore
//   Future<void> _saveVenue() async {
//     if (!_formKey.currentState!.validate()) {
//       _showSnackbar('Please fill out all fields.', Colors.red);
//       return;
//     }
//     if (_displayPicture == null) {
//       _showSnackbar('Please add a display picture.', Colors.red);
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       // Upload display picture
//       String displayImageUrl = await _uploadImage(
//         _displayPicture!,
//         'venues/${widget.adminPhoneNumber}/${DateTime.now().millisecondsSinceEpoch}_display.jpg',
//       );

//       // Upload reference images
//       List<String> referenceImageUrls = [];
//       for (File image in _referencePictures) {
//         String imageUrl = await _uploadImage(
//           image,
//           'venues/${widget.adminPhoneNumber}/${DateTime.now().millisecondsSinceEpoch}_ref.jpg',
//         );
//         referenceImageUrls.add(imageUrl);
//       }

//       // Save venue data in Firestore
//       final venueData = {
//         'venue_name': _venueNameController.text,
//         'address': _venueAddressController.text,
//         'description': _venueDescriptionController.text,
//         'location': _venueLocationController.text,
//         'contact': _venueContactController.text,
//         'hours': _venueHoursController.text,
//         'price': int.parse(_venuePriceController.text),
//         'admin_phone': widget.adminPhoneNumber, // Store admin phone number
//         'display_image': displayImageUrl,
//         'reference_images': referenceImageUrls,
//         'created_at': Timestamp.now(),
//       };

//       await FirebaseFirestore.instance.collection('venues').add(venueData);

//       _showSnackbar('Venue saved successfully!', Colors.green);
//       Navigator.pop(context);
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   const ProfilePage())); // Navigate back or to a success page
//     } catch (e) {
//       _showSnackbar('Failed to save venue: $e', Colors.red);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showSnackbar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Venue Form'),
//         backgroundColor: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (_isLoading) const LinearProgressIndicator(),
//                 const SizedBox(height: 16.0),

//                 // Upload Display Picture button and preview image
//                 Center(
//                   child: GestureDetector(
//                     onTap: () => _pickImage(ImageSource.gallery, true),
//                     child: _displayPicture == null
//                         ? Icon(
//                             Icons.add_circle,
//                             color: primaryColor,
//                             size: 50,
//                           )
//                         : Container(
//                             padding: const EdgeInsets.all(10),
//                             height: MediaQuery.of(context).size.height * 0.30,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               image: DecorationImage(
//                                 image: FileImage(_displayPicture!),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),

//                 // Upload Reference Photos button
//                 ElevatedButton.icon(
//                   onPressed: () => _pickImage(ImageSource.gallery, false),
//                   icon: const Icon(Icons.add_photo_alternate),
//                   label: const Text("Add Reference Photo"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryColor,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // Display reference photos preview
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _referencePictures.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.file(
//                             _referencePictures[index],
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),

//                 // Text Fields
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: _buildTextField(
//                           maxLines: 1,
//                           controller: _venueNameController,
//                           labelText: 'Venue Name'),
//                     ),
//                     // const SizedBox(width: 10,),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.6,
//                       child: _buildTextField(
//                           maxLines: 1,
//                           controller: _venueLocationController,
//                           labelText: 'Location'),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     Column(
//                       children: [
//                         // const Text('Starting from'),
//                         SizedBox(
//                           width: 100,
//                           child: _buildTextField(
//                               maxLines: 1,
//                               controller: _venuePriceController,
//                               labelText: 'Price',
//                               keyboardType: TextInputType.number),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 _buildTextField(
//                     maxLines: 2,
//                     controller: _venueAddressController,
//                     labelText: 'Venue Address'),
//                 _buildTextField(
//                     maxLines: 2,
//                     controller: _venueDescriptionController,
//                     labelText: 'Description'),
//                 _buildTextField(
//                     maxLines: 1,
//                     controller: _venueContactController,
//                     labelText: 'Contact',
//                     keyboardType: TextInputType.phone),
//                 _buildTextField(
//                     maxLines: 1,
//                     controller: _venueHoursController,
//                     labelText: 'Hours'),

//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _saveVenue,
//                     child: const Text('Submit'),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       backgroundColor: primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String labelText,
//     required int maxLines,
//     TextInputType keyboardType = TextInputType.text,
//     // int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: labelText,
//           labelStyle: const TextStyle(color: Colors.black),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.black),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//             borderSide: BorderSide(color: primaryColor),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $labelText';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
