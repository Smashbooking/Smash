// import 'dart:io';
// import 'package:flutter/material.dart';

// class VenuePage extends StatelessWidget {
//   final String venueName;
//   final String venueLocation;
//   final String venueAddress;
//   final String venueDescription;
//   final String venuePhone;
//   final String venueHours;
//   final String venuePrice;
//   final File? displayImage;
//   final List<File> referenceImages;
//   final Color primaryColor = const Color.fromRGBO(251, 20, 47, 0.965);

//   const VenuePage({
//     super.key,
//     required this.venueName,
//     required this.venueLocation,
//     required this.venueAddress,
//     required this.venueDescription,
//     required this.venuePhone,
//     required this.venueHours,
//     required this.venuePrice,
//     required this.displayImage,
//     required this.referenceImages,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Venue Details"),
//         backgroundColor: primaryColor,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (displayImage != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.file(
//                     displayImage!,
//                     height: 200,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               Text(
//                 venueName,
//                 style:
//                     const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 venueAddress,
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "₹$venuePrice",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 venueDescription,
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Icon(Icons.place, color: primaryColor),
//                   const SizedBox(width: 8),
//                   Text(
//                     venueLocation,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Icon(Icons.phone, color: primaryColor),
//                   const SizedBox(width: 8),
//                   Text(
//                     "Phone: $venuePhone",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Hours",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(venueHours),
//               const SizedBox(height: 20),
//               const Text(
//                 "Photos",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 100,
//                 child: referenceImages.isNotEmpty
//                     ? ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: referenceImages.length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(
//                                 referenceImages[index],
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     : const Center(
//                         child: Text(
//                           "No reference photos added",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
