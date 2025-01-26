import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'booking_page.dart';

class BookSportPage extends StatelessWidget {
  final String venueId;
  final String sportId;

  const BookSportPage(
      {super.key, required this.venueId, required this.sportId});
  Future<Map<String, String>> fetchVenueAndSportDetails(
      String venueId, String sportId) async {
    try {
      final venueDoc = await FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .get();

      if (!venueDoc.exists) {
        throw Exception("Venue not found in database.");
      }

      final venueData = venueDoc.data() as Map<String, dynamic>;
      final sportsCollection = FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .collection('sports');
      final sportDoc = await sportsCollection.doc(sportId).get();

      if (!sportDoc.exists) {
        throw Exception("Sport not found in database.");
      }

      final sportData = sportDoc.data() as Map<String, dynamic>;

      return {
        "venueName": venueData["name"] ?? venueId,
        "sportName": sportData["sport_name"] ?? sportId,
        "venueId": venueId, // IDs as fallback
        "sportId": sportId,
      };
    } catch (error) {
      throw Exception("Error fetching details: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Sport'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('venues')
            .doc(venueId)
            .collection('sports')
            .doc(sportId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(child: Text('Failed to load sport details.'));
          }

          // Extracting sport data and price chart
          final sport = snapshot.data!.data() as Map<String, dynamic>;
          final String sportName = sport['sport_name'] ?? 'Unknown Sport';
          final priceChart = sport['price'] as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sport Name
                Text(
                  sportName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),

                // Price Chart Title
                const Text(
                  'Price Chart',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                // Price Chart Details
                Expanded(
                  child: ListView(
                    children: priceChart.entries.map((entry) {
                      final dayRange = entry.key; // E.g., "Monday-Friday"
                      final timings = entry.value as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Day Range Header
                          Text(
                            dayRange,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),

                          // Timings and Prices
                          ...timings.entries.map((timingEntry) {
                            final timeSlot =
                                timingEntry.key; // E.g., "6:00 AM to 11:00 AM"
                            final price = timingEntry.value; // E.g., 500
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '$timeSlot: ₹$price/hr',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),

                          const SizedBox(
                              height: 16.0), // Spacing between sections
                        ],
                      );
                    }).toList(),
                  ),
                ),

                // Book Now Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print(venueId);
                      print(sportId);
                      // Navigate to BookingPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            venueId: venueId,
                            sportId: sportId,
                          ),
                        ),
                      ).catchError((error) {
                        // Handle navigation errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                    },
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
