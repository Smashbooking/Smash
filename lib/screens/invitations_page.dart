import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvitationsPage extends StatefulWidget {
  const InvitationsPage({super.key});

  @override
  _InvitationsPageState createState() => _InvitationsPageState();
}

class _InvitationsPageState extends State<InvitationsPage> {
  final _currentUser = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> _fetchTeamData(String teamId) async {
    final teamDoc =
        await FirebaseFirestore.instance.collection('teams').doc(teamId).get();

    if (!teamDoc.exists) {
      throw Exception("Team not found");
    }

    return teamDoc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("No user is logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Invitations")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Received Invitations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser.uid)
                  .collection('invites')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No received invitations."));
                }

                final receivedInvites = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: receivedInvites.length,
                  itemBuilder: (context, index) {
                    final invite = receivedInvites[index];
                    final teamId = invite['teamId'];
                    final senderId = invite['from'];

                    return FutureBuilder<Map<String, dynamic>>(
                      future: _fetchTeamData(teamId),
                      builder: (context, teamSnapshot) {
                        if (teamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading team details..."),
                          );
                        }

                        if (!teamSnapshot.hasData) {
                          return const ListTile(
                            title: Text("Failed to load team details."),
                          );
                        }

                        final teamData = teamSnapshot.data!;
                        final teamName = teamData['teamName'] ?? "Unnamed Team";
                        final sport = teamData['sport'] ?? "Unknown Sport";
                        final avatar = teamData['avatar'];

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(avatar),
                            ),
                            title: Text("TeamName: $teamName\t Sport:($sport)"),
                            subtitle: Text("Sent by: $senderId"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  onPressed: () {
                                    _acceptInvite(teamName, sport, avatar,
                                        senderId, teamId);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _rejectInvite(
                                        teamName, sport, senderId, teamId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Sent Invitations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_currentUser.uid)
                  .collection('sentInvites')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No sent invitations."));
                }

                final sentInvites = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: sentInvites.length,
                  itemBuilder: (context, index) {
                    final invite = sentInvites[index];
                    final teamId = invite['teamId'];
                    final recipientId = invite['to'];

                    return FutureBuilder<Map<String, dynamic>>(
                      future: _fetchTeamData(teamId),
                      builder: (context, teamSnapshot) {
                        if (teamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ListTile(
                            title: Text("Loading invitations..."),
                          );
                        }

                        if (!teamSnapshot.hasData) {
                          return const ListTile(
                            title: Text("No invitations sent"),
                          );
                        }

                        final teamData = teamSnapshot.data!;
                        final teamName = teamData['teamName'] ?? "Unnamed Team";
                        final sport = teamData['sport'] ?? "Unknown Sport";
                        final avatar = teamData['avatar'];
                        final status = invite['status'];

                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(avatar),
                            ),
                            title: Text("Team: $teamName\t Sports:($sport)"),
                            subtitle:
                                Text("Sent to: $recipientId\nStatus: $status"),
                          ),
                        );
                      },
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

  // Accept the invite and add user to the team
  Future<void> _acceptInvite(String teamName, String sport, String avatar,
      String senderId, String teamId) async {
    if (_currentUser == null) return;

    try {
      // Get the team document for the sender (senderId)
      final teamDoc =
          FirebaseFirestore.instance.collection('teams').doc(teamId);

      // Fetch the team data
      final teamSnapshot = await teamDoc.get();

      if (!teamSnapshot.exists) {
        throw Exception("Team does not exist.");
      }

      final teamData = teamSnapshot.data();
      final teamMembers =
          List<Map<String, dynamic>>.from(teamData?['members'] ?? []);

      // Fetch the current user's firstName from the 'users' collection
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser?.uid)
          .get();

      String currentUserName = currentUserDoc.data()?['firstName'] ?? "Unknown";

      // Add current user to the team members list
      teamMembers.add({
        "userId": _currentUser?.uid,
        "name": currentUserName,
        "role": '',
      });

      // Update the team document with the new list of members
      await teamDoc.update({
        "members": teamMembers,
      });

      // Send a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You joined the team $teamName!")),
        );
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .collection('teams')
          .doc(sport)
          .set({
        "name": currentUserName,
        "sport": sport,
        "role": '',
        "teamId": teamId,
        "joinedAt": Timestamp.now()
      });

      // Remove the invite from the invitees' collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .collection('invites')
          .where('teamName', isEqualTo: teamName)
          .where('sport', isEqualTo: sport)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      // Notify sender (add a "accepted" status to their invite)
      final inviteDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('invites')
          .where('teamName', isEqualTo: teamName)
          .where('sport', isEqualTo: sport)
          .limit(1);

      final inviteSnapshot = await inviteDoc.get();
      if (inviteSnapshot.docs.isNotEmpty) {
        await inviteSnapshot.docs.first.reference.update({
          'status': 'accepted',
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to accept invite: $e")),
        );
      }
    }
  }

  // Reject the invite and notify the sender
  Future<void> _rejectInvite(
      String teamName, String sport, String senderId, String teamId) async {
    if (_currentUser == null) return;

    try {
      // Notify sender (add a "declined" status to their invite)
      final inviteDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('invites')
          .where('teamName', isEqualTo: teamName)
          .where('sport', isEqualTo: sport)
          .limit(1);

      final inviteSnapshot = await inviteDoc.get();
      if (inviteSnapshot.docs.isNotEmpty) {
        await inviteSnapshot.docs.first.reference.update({
          'status': 'declined',
        });
      }
      final responseDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('sentInvites')
          .where('teamName', isEqualTo: teamName)
          .where('sport', isEqualTo: sport)
          .limit(1);

      final responseSnapshot = await responseDoc.get();
      if (responseSnapshot.docs.isNotEmpty) {
        await responseSnapshot.docs.first.reference.update({
          'status': 'declined',
        });
      }

      // Send a success message to the current user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You declined the invite to $teamName")),
      );

      // Remove the invite from the invitee's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser?.uid)
          .collection('invites')
          .where('teamName', isEqualTo: teamName)
          .where('sport', isEqualTo: sport)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to reject invite: $e")),
      );
    }
  }
}
