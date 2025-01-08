import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescriptionController =
      TextEditingController();

  static const Map<String, int> maxTeamSizes = {
    "Cricket": 6,
    "Football": 6,
    "Badminton": 2,
  };

  final List<String> _sports = ["Cricket", "Football", "Badminton"];
  final Map<String, IconData> _sportIcons = {
    "Cricket": Icons.sports_cricket,
    "Football": Icons.sports_soccer,
    "Badminton": Icons.sports_tennis,
  };

  final List<String> _avatars = [
    'https://cdn-icons-png.flaticon.com/128/924/924915.png',
    'https://cdn-icons-png.flaticon.com/128/11891/11891916.png',
    'https://cdn-icons-png.flaticon.com/128/15468/15468458.png',
  ];

  String? _selectedSport = "Cricket";
  String? _selectedAvatar;
  // List<Map<String, dynamic>> _teamMembers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = _avatars.first; // Default avatar
  }

  // Future<void> _invitePlayer(String playerId) async {
  //   try {
  //     final currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser == null) throw Exception("User not logged in");

  //     // Fetch the player's name from Firestore
  //     final playerDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(playerId)
  //         .get();
  //     // Fetch the current user's name from Firestore
  //     final currentplayerDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .get();

  //     if (!playerDoc.exists) {
  //       throw Exception("Player not found");
  //     }
  //     if (!currentplayerDoc.exists) {
  //       throw Exception("Player not found");
  //     }

  //     final String cUserName =
  //         currentplayerDoc.data()?['firstName'] ?? "Sender";
  //     final String playerName = playerDoc.data()?['firstName'] ?? "receiver";

  //     final inviteDoc = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(playerId)
  //         .collection('invites')
  //         .doc();

  //     await inviteDoc.set({
  //       "avatar": _selectedAvatar,
  //       "teamName": _teamNameController.text,
  //       "sport": _selectedSport,
  //       "from": cUserName,
  //       "timestamp": Timestamp.now(),
  //       "status": "pending",
  //     });

  //     final sentInvite = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUser.uid)
  //         .collection('sentInvites')
  //         .doc();

  //     await sentInvite.set({
  //       "avatar": _selectedAvatar,
  //       "teamName": _teamNameController.text,
  //       "sport": _selectedSport,
  //       "to": playerName,
  //       "timestamp": Timestamp.now(),
  //       "status": "pending",
  //     });

  //     if(mounted){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Invite sent to $playerName")),
  //     );
  //     }
  //   } catch (e) {
  //     if(mounted){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to send invite: $e")),
  //     );
  //     }
  //   }
  // }

  // Check if user is already in a team for the selected sport
  Future<bool> _checkUserTeamStatus(String userId, String sport) async {
    final QuerySnapshot teamSnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('sport', isEqualTo: sport)
        .where('memberIds', arrayContains: userId)
        .get();

    return teamSnapshot.docs.isNotEmpty;
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // Fetch the current user's name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User details not found in Firestore.");
      }

      final String userName = userDoc.data()?['firstName'] ?? "Anonymous";

      // Check if user is already in a team for this sport
      final bool isInTeam =
          await _checkUserTeamStatus(currentUser.uid, _selectedSport!);
      if (isInTeam) {
        throw Exception("You are already in a team for ${_selectedSport!}");
      }

      // Create new team document
      final teamDoc = FirebaseFirestore.instance.collection('teams').doc();
      String teamName = _teamNameController.text;
      final teamData = {
        "teamId": teamDoc.id,
        "teamName": _teamNameController.text,
        "teamDescription": _teamDescriptionController.text,
        "sport": _selectedSport,
        "avatar": _selectedAvatar,
        "createdBy": currentUser.uid,
        "createdAt": Timestamp.now(),
        "status": "active",
        "maxSize": maxTeamSizes[_selectedSport],
        "members": [
          {
            "userId": currentUser.uid,
            "name": userName,
            "role": "captain",
            "joinedAt": Timestamp.now(),
          }
        ],
        "memberIds": [currentUser.uid], // For easier querying
      };

      await teamDoc.set(teamData);

      // Add team reference to user's teams
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('teams')
          .doc(_selectedSport)
          .set({
        "teamId": teamDoc.id,
        "name": userName,
        "role": "captain",
        "sport": _selectedSport,
        "joinedAt": Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team $teamName created successfully!')),
        );

        Navigator.pop(context);
      } // Return to previous screen
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create team: $e")),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Create Team")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar Selection
              const Text("Choose Avatar"),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _avatars.map((avatarUrl) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarUrl;
                        });
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(avatarUrl),
                          radius: 40,
                          backgroundColor: avatarUrl == _selectedAvatar
                              ? Colors.blue
                              : Colors.grey.shade200,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),

              // Team Name
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(
                  labelText: "Team Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a team name.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Team Description
              TextFormField(
                controller: _teamDescriptionController,
                decoration: const InputDecoration(
                  labelText: "Team Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Sport Selection
              const Text(
                "Select Sport",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _sports.map((sport) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSport = sport;
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          _sportIcons[sport],
                          color: _selectedSport == sport
                              ? Colors.blue
                              : Colors.grey,
                          size: 50,
                        ),
                        Text(sport),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 100),
              // Create Team Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createTeam,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Create Team"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// -------------------------------------------------------------------------------------------------
