import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smash/pages/challenges.dart';
import 'package:smash/pages/teams_page.dart';
import 'package:smash/pages/view_teams.dart';
import 'package:smash/screens/invitations_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../authentication/login.dart';
import 'display_page.dart';
import 'details_page.dart';
import 'profile_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String userName = "NA";
  bool isloading = true;
  bool isAdmin = false;
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
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      //Get current user's uid
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is signed in.");
      }

      final String uid = currentUser.uid;

      // Query Firestore for user data
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          userName = userData['firstName'] ?? "No Name";
          isAdmin = userData['isAdmin'] ?? false;
          // userEmail = userData['email'] ?? "No Email";
          // userPhone = userData['phoneNumber'] ?? "No Phone Number";
          isloading = false;
        });
      } else {
        throw Exception("User data not found.");
      }
    } catch (e) {
      setState(() {
        userName = "Error";
        isAdmin = false;
        // userEmail = "Error";
        // userPhone = "Error";
        isloading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load user details: $e")),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      // Check if the widget is still mounted
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  TextStyle drawerStyle = const TextStyle(fontSize: 15, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Row(
                  children: [
                    const Text('Welcome,',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      userName,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                )),
            // Conditionally show "Create Team" and "View Team" if isAdmin is true
            if (isAdmin) ...[
              ListTile(
                leading: const Icon(Icons.group_add),
                title: const Text('Create Team'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.group_rounded),
                title: const Text('View Team'),
                onTap: () {
                  // Navigate to View Team screen
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: Text(
                'View Team',
                style: drawerStyle,
              ),
              onTap: () {
                // viewTeam(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ViewTeamPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: Text(
                'My Bookings',
                style: drawerStyle,
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_added_outlined),
              title: Text(
                'Invitations',
                style: drawerStyle,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvitationsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(
                'Log Out',
                style: drawerStyle,
              ),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
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
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Opens the drawer
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_outline))
        ],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "S M A S H",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 10,
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/venue.png',
                      height: 30,
                    ),
                    Text(
                      "Venues",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/cricket.png',
                      height: 30,
                      color: Colors.black,
                    ),
                    Text("Turfs"),
                  ],
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/stadium.png',
                      height: 30,
                    ),
                    Text("Events"),
                  ],
                ),
                // Column(
                //   children: [
                //     Image.asset(
                //       'assets/images/venue.png',
                //       height: 30,
                //     ),
                //     Text("Basketball"),
                //   ],
                // ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/shuttlecock.png',
                      height: 30,
                    ),
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
                              final venueData =
                                  doc.data() as Map<String, dynamic>;
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
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsPage(venueId: doc.id))),
                                    child: Column(
                                      children: [
                                        // Image occupies 60% of the card
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
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
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),

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
                                  builder: (context) => const TeamsPage())),
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
