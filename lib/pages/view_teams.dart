import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewTeamPage extends StatefulWidget {
  const ViewTeamPage({Key? key}) : super(key: key);

  @override
  _ViewTeamPageState createState() => _ViewTeamPageState();
}

class _ViewTeamPageState extends State<ViewTeamPage> {
  String? teamAvatar;
  final currentUser = FirebaseAuth.instance.currentUser;
  String? _selectedSport; // To track the selected sport
  String? teamId; // To store the team ID for the selected sport
  Map<String, dynamic>? _teamData; // To store the fetched team data
  List<String> _sports = []; // Available sports for the user
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  Future<void> _fetchSports() async {
    if (currentUser == null) {
      setState(() {
        _error = "No user is logged in.";
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch sports associated with the user
      final teamsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('teams')
          .get();

      if (teamsSnapshot.docs.isEmpty) {
        setState(() {
          _error = "No sports found for this user.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _sports = teamsSnapshot.docs.map((doc) => doc.id).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch sports: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchTeamData(String sport) async {
    if (currentUser == null) return;

    setState(() {
      _isLoading = true;
      _teamData = null;
    });

    try {
      // Get teamId for the selected sport
      final sportDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('teams')
          .doc(sport)
          .get();

      if (!sportDoc.exists) {
        setState(() {
          _teamData = null;
          teamId = null;
          _isLoading = false;
        });
        return;
      }
      teamAvatar = sportDoc.data()?['avatar'];
      teamId = sportDoc.data()?['teamId'];
      if (teamId == null) throw Exception("Team ID not found.");

      // Fetch team data from the teams collection
      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .get();

      if (!teamDoc.exists) {
        setState(() {
          _teamData = null;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _teamData = teamDoc.data();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to fetch team data: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _invitePlayer(String playerId, String teamID) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      final teamDoc = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamID)
          .get();
      String avatar = teamDoc.data()?['avatar'];
      String teamName = teamDoc.data()?['teamName'];

      // Fetch the player's name from Firestore
      final playerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(playerId)
          .get();

      // Fetch the current user's name from Firestore
      final currentplayerDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!playerDoc.exists) {
        throw Exception("Player not found");
      }
      if (!currentplayerDoc.exists) {
        throw Exception("Current user not found");
      }

      final String cUserName =
          currentplayerDoc.data()?['firstName'] ?? "Sender";
      final String playerName = playerDoc.data()?['firstName'] ?? "receiver";

      final inviteDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(playerId)
          .collection('invites')
          .doc();

      await inviteDoc.set({
        "avatar": avatar,
        "teamId": teamId, // Added from ViewTeams logic
        "teamName": teamName,
        "sport": _selectedSport,
        "from": cUserName,
        "timestamp": Timestamp.now(),
        "status": "pending",
      });

      final sentInvite = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('sentInvites')
          .doc();

      await sentInvite.set({
        "avatar": avatar,
        "teamId": teamId, // Added from ViewTeams logic
        "teamName": teamName,
        "sport": _selectedSport,
        "to": playerName,
        "timestamp": Timestamp.now(),
        "status": "pending",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invite sent to $playerName")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send invite: $e")),
      );
    }
  }

  void _showAddPlayerModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Players"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Search Users"),
                Tab(text: "Phone Contacts"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Search Users Tab
              _buildSearchUsersTab(),

              // Static Phone Contacts Tab
              _buildPhoneContactsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchUsersTab() {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('isAdmin', isEqualTo: false) // Include only non-admin users
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        final users = snapshot.data!.docs.where((doc) {
          final userId = doc.id;
          return currentUser != null &&
              userId != currentUser.uid; // Exclude current user
        }).toList();

        if (users.isEmpty) {
          return const Center(child: Text("No users available to invite"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userId = user.id;
            final userName = user['firstName'] ?? 'Unknown';

            return ListTile(
              title: Text(userName),
              // subtitle: Text(userId),
              trailing: ElevatedButton(
                onPressed: () {
                  _invitePlayer(userId, teamId!);
                },
                child: const Text("Invite"),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhoneContactsTab() {
    final staticContacts = [
      {"name": "John Doe", "phone": "1234567890"},
      {"name": "Jane Smith", "phone": "0987654321"},
    ];

    return ListView.builder(
      itemCount: staticContacts.length,
      itemBuilder: (context, index) {
        final contact = staticContacts[index];
        return ListTile(
          title: Text(contact['name']!),
          subtitle: Text(contact['phone']!),
          trailing: ElevatedButton(
            onPressed: () {
              _invitePlayer(contact['phone']!, teamId!);
            },
            child: const Text("Invite"),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Teams")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select a Sport:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display sport chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _sports.map((sport) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                label: Text(sport),
                                selected: _selectedSport == sport,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedSport = sport;
                                    });
                                    _fetchTeamData(sport);
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display team details or "No team created" message
                      _teamData != null
                          ? Container(
                              width: double.infinity,
                              child: Card(
                                color: Colors.white60,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Team Name Header
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "Team: ${_teamData!['teamName'] ?? 'Unnamed Team'}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _selectedSport ?? '',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 32),

                                      // Players Grid
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 0.8,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                        ),
                                        itemCount: (_teamData!['members']
                                                    as List<dynamic>? ??
                                                [])
                                            .length,
                                        itemBuilder: (context, index) {
                                          teamAvatar = _teamData!['avatar'];
                                          final player = (_teamData!['members']
                                              as List<dynamic>)[index];
                                          final playerName =
                                              player['name'] ?? "Unknown";
                                          final playerRole =
                                              player['role'] ?? "Player";

                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                  child: Image.network(
                                                      teamAvatar!),
                                                ),
                                                const SizedBox(height: 8),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Text(
                                                    playerName,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  playerRole
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 24),

                                      // Action Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: _showAddPlayerModal,
                                              icon:
                                                  const Icon(Icons.person_add),
                                              label: const Text("Add Players"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () =>
                                                  _leaveTeam(teamId!),
                                              icon:
                                                  const Icon(Icons.exit_to_app),
                                              label: const Text("Leave Team"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red[50],
                                                foregroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text("no teams"),
                            )
                    ],
                  ),
      ),
    );
  }

  Future<void> _leaveTeam(String teamId) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // Get user data for the team update
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final userName = userDoc.data()?['firstName'] ?? 'Unknown';

      // First, update the teams collection
      final teamRef =
          FirebaseFirestore.instance.collection('teams').doc(teamId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final teamDoc = await transaction.get(teamRef);

        if (!teamDoc.exists) {
          throw Exception("Team not found");
        }

        List<dynamic> members = List.from(teamDoc.data()?['members'] ?? []);
        members.removeWhere((member) => member['name'] == userName);

        transaction.update(teamRef, {'members': members});
      });

      // Then, remove the team reference from user's teams collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('teams')
          .doc(_selectedSport)
          .delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Successfully left the team"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate back or refresh the page
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to leave team: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            left: 20,
            right: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
