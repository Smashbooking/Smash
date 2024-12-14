// -----------------------------------------------------------------------------------------------------------
// import 'package:flutter/material.dart';
// import 'dart:io';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   final List<Venue> venues = [
//     Venue(
//       name: "Backwoods",
//       imagePath: "assets/images/turf1.jpeg",
//       price: "\$20/hour",
//       sport: "Basketball",
//       location: "Downtown",
//       address: "123 Main Street",
//       description: "A great venue for basketball lovers.",
//       phone: "123-456-7890",
//       hours: "8:00 AM - 8:00 PM",
//       referenceImages: [],
//     ),
//     Venue(
//       name: "K&K Turf",
//       imagePath: "assets/images/turf2.jpeg",
//       price: "\$15/hour",
//       sport: "Turf",
//       location: "Eastside",
//       address: "456 Turf Avenue",
//       description: "Top-quality turf for soccer enthusiasts.",
//       phone: "987-654-3210",
//       hours: "6:00 AM - 10:00 PM",
//       referenceImages: [],
//     ),
//     Venue(
//       name: "Gurukul",
//       imagePath: "assets/images/turf3.jpeg",
//       price: "\$10/hour",
//       sport: "Badminton",
//       location: "Westside",
//       address: "789 Court Road",
//       description: "Perfect for professional badminton games.",
//       phone: "456-123-7890",
//       hours: "7:00 AM - 9:00 PM",
//       referenceImages: [],
//     ),
//   ];

//   List<Venue> filteredVenues = [];
//   String? selectedSport;

//   @override
//   void initState() {
//     super.initState();
//     // Initially show all venues
//     filteredVenues = venues;
//   }

//   void filterVenues(String sport) {
//     setState(() {
//       selectedSport = sport;
//       filteredVenues = venues.where((venue) => venue.sport == sport).toList();
//     });
//   }

//   void resetFilter() {
//     setState(() {
//       selectedSport = null;
//       filteredVenues = venues;
//     });
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("It all starts here."),
//       ),
//       body: _selectedIndex == 0
//           ? Container(
//               margin: const EdgeInsets.all(15),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Aurangabad",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       GestureDetector(
//                         onTap: () => filterVenues("Events"),
//                         child: const Column(
//                           children:  [
//                             Icon(Icons.event),
//                             Text("Events"),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => filterVenues("Basketball"),
//                         child: const Column(
//                           children: [
//                             Icon(Icons.sports_basketball),
//                             Text("Basketball"),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => filterVenues("Turf"),
//                         child: const Column(
//                           children:  [
//                             Icon(Icons.location_city),
//                             Text("Turfs"),
//                           ],
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () => filterVenues("Badminton"),
//                         child: const Column(
//                           children:  [
//                             Icon(Icons.sports_baseball),
//                             Text("Badminton"),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   if (selectedSport != null)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Showing ${filteredVenues.length} venues for $selectedSport",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         ...filteredVenues.map((venue) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => VenuePage(venue: venue),
//                                 ),
//                               );
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0, horizontal: 10.0),
//                               child: Card(
//                                 elevation: 3,
//                                 child: ListTile(
//                                   leading: Image.asset(
//                                     venue.imagePath,
//                                     width: 50,
//                                     height: 50,
//                                     fit: BoxFit.cover,
//                                   ),
//                                   title: Text(venue.name),
//                                   subtitle: Text(venue.price),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                         const SizedBox(height: 10),
//                         Center(
//                           child: ElevatedButton(
//                             onPressed: resetFilter,
//                             child: const Text("Clear Filter"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   if (selectedSport == null) ...[
//                     const Text(
//                       "Recommended Venues",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: venues.map((venue) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => VenuePage(venue: venue),
//                                 ),
//                               );
//                             },
//                             child: VenueCard(venue: venue),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     const Text(
//                       "Recommended Turfs",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: venues
//                             .where((venue) => venue.sport == "Turf")
//                             .map((venue) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => VenuePage(venue: venue),
//                                 ),
//                               );
//                             },
//                             child: VenueCard(venue: venue),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             )
//           : Center(
//               child: Text(
//                 "Selected tab index: $_selectedIndex", // Placeholder for other screens
//                 style: const TextStyle(fontSize: 24),
//               ),
//             ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add),
//             label: 'Book',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorite',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//         selectedItemColor: Colors.redAccent,
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//       ),
//     );
//   }
// }

// class Venue {
//   final String name;
//   final String imagePath;
//   final String price;
//   final String sport;
//   final String location;
//   final String address;
//   final String description;
//   final String phone;
//   final String hours;
//   final List<File> referenceImages;

//   Venue({
//     required this.name,
//     required this.imagePath,
//     required this.price,
//     required this.sport,
//     required this.location,
//     required this.address,
//     required this.description,
//     required this.phone,
//     required this.hours,
//     required this.referenceImages,
//   });
// }

// class VenueCard extends StatelessWidget {
//   final Venue venue;

//   const VenueCard({required this.venue, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.15,
//       width: MediaQuery.of(context).size.width * 0.4,
//       child: Card(
//         elevation: 3,
//         child: Column(
//           children: [
//             Expanded(
//               child: Image.asset(
//                 venue.imagePath,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 venue.name,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VenuePage extends StatelessWidget {
//   final Venue venue;

//   const VenuePage({required this.venue, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(venue.name),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               venue.imagePath,
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 200,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               venue.name,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               venue.price,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               venue.location,
//               style: const TextStyle(fontSize: 18),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               venue.description,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ---------------------------------------------------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smash/pages/challenges.dart';
import 'package:smash/pages/teams.dart';
import 'package:url_launcher/url_launcher.dart';
import 'display_page.dart';
import 'details_page.dart';
import '../pages/saved_page.dart';
import 'profile_page.dart';
import '../pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    // const SearchPage(),
    const DisplayPage(),
    // const SavedPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Book',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.favorite),
          //   label: 'Favorite',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

class Venue {
  final String name;
  final String imagePath;
  final String price;

  Venue({required this.name, required this.imagePath, required this.price});
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        leading: const Icon(Icons.menu),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon(Icons.menu),

            Text(
              "S M A S H",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Icon(Icons.favorite_outline)
              ],
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.location_city),
                    Text("Venues"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.location_city),
                    Text("Turfs"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.location_city),
                    Text("Events"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.sports_basketball),
                    Text("Basketball"),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.sports_baseball),
                    Text("Badminton"),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            // Advertising container
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              child: const Card(
                color: Colors.grey,
                shadowColor: Colors.black,
                child: Center(child: Text("Advertising here....")),
              ),
            ),

            // Recommended venues section
            Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('venues')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No venues available."));
                    }

                    final venues = snapshot.data!.docs;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recommended Venues",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "See all",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: venues.map((doc) {
                              // Safely fetch Firestore fields and convert to String
                              final venueName =
                                  doc['venue_name'] ?? 'Unknown Venue';
                              final price = doc['price']?.toString() ?? 'N/A';
                              final location =
                                  doc['location']?.toString() ?? '';

                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      // Image occupies 60% of the card
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            'assets/images/turf1.jpeg', // Static image
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              venueName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Starting from $price",
                                                  style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.directions,
                                                          color: Colors.blue),
                                                      onPressed: () async {
                                                        if (location
                                                            .isNotEmpty) {
                                                          final url = Uri.parse(
                                                              'https://www.google.com/maps/search/?api=1&query=$location');
                                                          if (await canLaunchUrl(
                                                              url)) {
                                                            await launchUrl(
                                                                url);
                                                          } else {
                                                            throw 'Could not launch $url';
                                                          }
                                                        }
                                                      },
                                                    ),
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
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: venues.map((venue) {
                //       return VenueCard(venue: venue);
                //     }).toList(),
                //   ),
                // ),
                // -----------------------------------------------------------------------------------------------

                // -----------------------------------------------------------------------------------------------

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       height: MediaQuery.of(context).size.height * 0.15,
                //       width: MediaQuery.of(context).size.width * 0.40,
                //       child: Card(
                //         child: Column(
                //           children: [
                //             Image.asset(
                //               'assets/images/turf1.jpeg',
                //               cacheHeight: 100,
                //             ),
                //             Text('Teams'),
                //           ],
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: MediaQuery.of(context).size.height * 0.15,
                //       width: MediaQuery.of(context).size.width * 0.40,
                //       child: Card(
                //         child: Column(
                //           children: [
                //             Image.asset(
                //               'assets/images/turf2.jpeg',
                //               cacheHeight: 100,
                //             ),
                //             const Text('Challenges'),
                //           ],
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Enhanced Teams and Challenges Section
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Teams())),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/team.jpg',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: double.infinity,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Text(
                                    'Teams',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Challenges())),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/challenge.jpg',
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: double.infinity,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Text(
                                    'Challenges',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final Venue venue;

  const VenueCard({required this.venue, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                venue.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(venue.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(venue.price, style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
