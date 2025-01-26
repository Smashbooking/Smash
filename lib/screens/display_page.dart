
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'details_page.dart'; // The detailed venue info page

class DisplayPage extends StatelessWidget {
  const DisplayPage({Key? key}) : super(key: key);

  // Method to open Google Maps with the venue location
  void _openGoogleMaps(String location) async {
    final Uri url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Aurangabad'),
                Icon(Icons.keyboard_arrow_down_outlined),
              ],
            ),
            Row(
              children: [
                Icon(Icons.notifications),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.person)
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.white24,
      body: Column(
        children: [
          // Components above the list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Add a search bar
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.filter_alt),
                    hintText: 'Search for a venue...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (query) {
                    // Handle search logic (optional)
                  },
                ),
                const SizedBox(height: 10),
                // Add a filter button (optional)
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       // Handle filter logic (optional)
                //     },
                //     icon: const Icon(Icons.filter_alt),
                //     label: const Text('Filter'),
                //   ),
                // ),
              ],
            ),
          ),

          // List of venues
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('venues').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load venues.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No venues available.'));
                }

                final venues = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    final venue = venues[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigate to VenueDetailsPage with the selected venue data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(
                                  venueId: venues[index].id,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Venue Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: Image.asset(
                                  'assets/images/turf3.jpeg',
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Venue Name and Ratings
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          venue['venue_name'] ??
                                              'Unknown Venue',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => Icon(
                                              index < (venue['rating'] ?? 0)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Get Directions
                                    TextButton.icon(
                                      onPressed: () => _openGoogleMaps(
                                          venue['location'] ?? ''),
                                      icon: const Icon(Icons.directions),
                                      label: const Text('Get Directions'),
                                    ),
                                    const Divider(),
                                    // Price Info
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Price Starting From',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                        Text(
                                          '₹${venue['price'] ?? 'N/A'}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}