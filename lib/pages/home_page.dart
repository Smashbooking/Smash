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
import 'booking_page.dart';
import 'details_page.dart';
import 'saved_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    const SearchPage(),
    const BookingPage(),
    const SavedPage(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
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

  final List<Venue> venues = [
    Venue(
        name: "Backwoods",
        imagePath: "assets/images/turf1.jpeg",
        price: "\$20/hour"),
    Venue(
        name: "K&K Turf",
        imagePath: "assets/images/turf2.jpeg",
        price: "\$15/hour"),
    Venue(
        name: "Gurukul",
        imagePath: "assets/images/turf3.jpeg",
        price: "\$10/hour"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Aurangabad",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.keyboard_arrow_down)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recommended Venues",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                    children: venues.map((venue) {
                      return VenueCard(venue: venue);
                    }).toList(),
                  ),
                ),
                // -----------------------------------------------------------------------------------------------

                // -----------------------------------------------------------------------------------------------

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recommended Turfs",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: venues.map((venue) {
                      return VenueCard(venue: venue);
                    }).toList(),
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
