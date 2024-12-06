import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsPage extends StatelessWidget {
  final String venueId;

  const DetailsPage({Key? key, required this.venueId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('venues').doc(venueId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load venue details.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Venue not found.'));
          }

          final venue = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Image
                if (venue['display_image'] != null)
                  Image.network(
                    venue['display_image'],
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                Image.asset(
                  'assets/images/turf1.jpeg',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),

                // Venue Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      venue['venue_name'] ?? 'Unknown Venue',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.favorite_border_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.share)
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8.0),

                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.grey), // Time Icon
                    const SizedBox(width: 8),
                    Text('Hours: ${venue['hours'] ?? 'N/A'}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.grey), // Location Icon
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        venue['address'] ??
                            'N/A', // Replace with your fetched location
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        softWrap: true, // Allows text to wrap to the next line
                      ),
                    ),
                  ],
                ),

                // Address
                // Text(venue['address'] ?? 'N/A'),
                const Divider(),

                // Description
                // const Text(
                //   'Description',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 8.0),
                // Text(venue['description'] ?? 'N/A'),
                // const Divider(),
                // Description
                const Text(
                  'Amenities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                const Row(
                  children: [
                    Card(
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Parking'),
                      ),
                    ),
                    Card(
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Restroom'),
                      ),
                    ),
                    Card(
                      shadowColor: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Refreshments'),
                      ),
                    ),
                  ],
                ),
                const Divider(),

                // Contact and Hours
                const Text(
                  'Contact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text('Phone: ${venue['contact'] ?? 'N/A'}'),
                const SizedBox(height: 8.0),
                Text('Hours: ${venue['hours'] ?? 'N/A'}'),
                const Divider(),

                // Price
                Text(
                  'Price Starting From: ₹${venue['price'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        foregroundColor: Colors.red,
                        elevation: 5, // Elevation (shadow)
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32), // Padding
                      ),
                      onPressed: () {},
                      child: const Text('Bulk/Corporate'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 5, // Elevation (shadow)
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32), // Padding
                      ),
                      onPressed: () {},
                      child: const Text('Book'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
