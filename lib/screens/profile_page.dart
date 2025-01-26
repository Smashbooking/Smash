import 'package:flutter/material.dart';
import 'package:smash/components/my_tile.dart';
import 'package:smash/screens/notifications_page.dart';
import 'package:smash/screens/support.dart';
import 'package:smash/screens/terms_and_conditions_page.dart';
import 'package:smash/screens/user_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //profile text
                //profile image
                ClipRect(
                  child: Icon(
                    Icons.person,
                    size: MediaQuery.of(context).size.height * 0.20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //username
                const Text(
                  "UserName",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(),
                Column(
                  children: [
                    MyTile(
                        text: "Manage Profile",
                        icon: Icons.person,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile()));
                        }),
                    MyTile(
                        text: "Manage Bookings",
                        icon: Icons.book_online_outlined,
                        onTap: () {}),
                    MyTile(
                        text: "Notifications",
                        icon: Icons.notifications,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage()));
                        }),
                    MyTile(
                        text: "Terms and Conditions",
                        icon: Icons.rule,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const TermsConditionsPage()));
                        }),
                    MyTile(
                        text: "Support",
                        icon: Icons.help,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SupportPage()));
                        }),
                    MyTile(text: "Log Out", icon: Icons.logout, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
