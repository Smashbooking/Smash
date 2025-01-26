import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smash/pages/sports/booking_page.dart';
import '../pages/sports/book_sport_page.dart';

class DetailsPage extends StatelessWidget {
  final String venueId;

  const DetailsPage({super.key, required this.venueId});

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
                // Text('Hours: ${venue['hours'] ?? 'N/A'}'),
                const Divider(),
                Column(
                  children: [
                    const Text('Available Sports',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SportsColumn(venueId: venueId),
                  ],
                ),

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

class SportsColumn extends StatelessWidget {
  final String venueId;

  const SportsColumn({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .collection('sports')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Failed to load sports.');
        }

        final sports = snapshot.data!.docs;

        if (sports.isEmpty) {
          return const Text('No sports available.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sports.map((sportDoc) {
            final sportData = sportDoc.data() as Map<String, dynamic>;
            return ListTile(
              leading: const Icon(Icons.sports),
              title: Text(sportData['sport_name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSportPage(
                      venueId: venueId,
                      sportId: sportDoc.id,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
