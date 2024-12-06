import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VenueDetailsPage extends StatefulWidget {
  const VenueDetailsPage({super.key});

  @override
  _VenueDetailsPageState createState() => _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {
  Map<String, dynamic>? venueData; // Holds venue details
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVenueDetailsByPhoneNumber();
  }

  Future<void> fetchVenueDetailsByPhoneNumber() async {
    try {
      // Get the currently signed-in user's phone number
      final user = FirebaseAuth.instance.currentUser;
      final userPhoneNumber = user?.phoneNumber;

      if (userPhoneNumber == null) {
        throw Exception("User is not signed in or phone number not available.");
      }

      // Query Firestore for venue data matching the phone number
      final querySnapshot = await FirebaseFirestore.instance
          .collection('venues')
          .where('admin_phone', isEqualTo: userPhoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          venueData = querySnapshot.docs.first.data(); // Get the first match
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No venue found for this user!')),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch venue details: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Details'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : venueData == null
              ? const Center(child: Text('No data available')) // No data found
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Image from firebase storage....
                        // if (venueData!['display_image'] != null)
                        //     Row(
                        //     children: [
                        //       Expanded(
                        //         child: Image.network(
                        //           venueData!['display_image'],
                        //           height: 150,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 16.0),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             venueData!['venue_name'] ?? '',
                        //             style: const TextStyle(
                        //                 fontSize: 24.0,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //           Text(venueData!['address'] ?? ''),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/turf3.jpeg'),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Price: ₹${venueData!['price'] ?? ''}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Card(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  venueData!['venue_name'] ?? '',
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.share),
                                Icon(Icons.bookmark_add)
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),

                        // Venue Details
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              venueData!['description'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text('Contact: ${venueData!['contact'] ?? ''}'),
                        Text('Hours: ${venueData!['hours'] ?? ''}'),

                        const SizedBox(height: 16.0),

                        // Reference Photos
                        const Text(
                          'Photos',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 100,
                          child: venueData!['reference_images'] != null
                              ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      (venueData!['reference_images'] as List)
                                          .length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        (venueData!['reference_images']
                                            as List)[index],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text('No reference photos')),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
