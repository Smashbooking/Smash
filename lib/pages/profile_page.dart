import 'package:flutter/material.dart';
import 'package:smash/components/my_tile.dart';

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
                const Text(
                  "Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                //profile image
                ClipRect(
                  child: Icon(
                    Icons.person_2_outlined,
                    size: MediaQuery.of(context).size.height * 0.10,
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
                        onTap: () {}),
                    MyTile(
                        text: "Manage Bookings",
                        icon: Icons.book_online_outlined,
                        onTap: () {}),
                    MyTile(
                        text: "Notifications",
                        icon: Icons.notifications,
                        onTap: () {}),
                    MyTile(
                        text: "Terms and Conditions",
                        icon: Icons.rule,
                        onTap: () {}),
                    MyTile(text: "Support", icon: Icons.help, onTap: () {}),
                    MyTile(text: "Log Out", icon: Icons.logout, onTap: () {}),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
