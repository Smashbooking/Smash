import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smash/admin/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            _handleMenuSelection(value);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'bookings',
              child: ListTile(
                leading: Icon(Icons.book),
                title: Text('Bookings'),
              ),
            ),
            const PopupMenuItem(
              value: 'ratings',
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Ratings'),
              ),
            ),
            const PopupMenuItem(
              value: 'addSports',
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Sports'),
              ),
            ),
            const PopupMenuItem(
              value: 'venueInfo',
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text('Venue Information'),
              ),
            ),
            const PopupMenuItem(
              value: 'editProfile',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Top Container with Gradient Background
          Container(
            height:
                120, // Height to only cover the upper half of profile picture
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red,
                  Colors.redAccent,
                ],
              ),
            ),
          ),

          // Profile Picture overlapping the container
          Positioned(
            top:
                60, // Half of container height to position the profile picture halfway over it
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage(
                    'assets/images/profile.jpg', // Replace with your image path
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'John Doe', // Replace with actual user name
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 300,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Bar Chart Section
                const Text(
                  '7-Day Earnings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildBarChart(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Row(
                  children: [
                    SizedBox(height: 15),
                    Text(
                      'Rating: 4.0',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Icon(Icons.star, color: Colors.yellow),
                        Icon(Icons.star, color: Colors.yellow),
                        Icon(Icons.star, color: Colors.yellow),
                        Icon(Icons.star_border, color: Colors.grey),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Handle PopupMenu item selection
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'bookings':
        // Navigate to Bookings page or perform related action
        break;
      case 'ratings':
        // Navigate to Ratings page or perform related action
        break;
      case 'addSports':
        // Navigate to Add Sports page or perform related action
        break;
      case 'venueInfo':
        // Navigate to Venue Information page or perform related action
        break;
      case 'editProfile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ),
        );
        break;
    }
  }

  // Bar chart builder function
  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            maxY: 20,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 5, // Adjust interval for correct Y-axis values
                  getTitlesWidget: (double value, TitleMeta meta) {
                    return Text(value.toInt().toString());
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    const days = [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ];
                    return Text(days[value.toInt() % days.length]);
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              for (int i = 0; i < 7; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: (i + 5).toDouble(),
                      color: const Color.fromARGB(255, 255, 64, 64),
                      width: 15,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
