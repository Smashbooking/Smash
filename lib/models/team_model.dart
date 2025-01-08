import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamMember {
  final String name;
  final String role;

  TeamMember({required this.name, required this.role});

  Map<String, dynamic> toJson() => {
        'name': name,
        'role': role,
      };

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? 'Player',
    );
  }
}

class Team {
  final String id;
  final String name;
  final String sport;
  final String avatar;
  final List<TeamMember> members;

  Team({
    required this.id,
    required this.name,
    required this.sport,
    required this.avatar,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'teamId': id,
        'teamName': name,
        'sport': sport,
        'avatar': avatar,
        'members': members.map((member) => member.toJson()).toList(),
      };

  factory Team.fromJson(Map<String, dynamic> json) {
    List<TeamMember> membersList = [];
    if (json['members'] != null) {
      membersList = (json['members'] as List)
          .map((member) => TeamMember.fromJson(member))
          .toList();
    }

    return Team(
      id: json['teamId'] ?? '',
      name: json['teamName'] ?? 'Unnamed Team',
      sport: json['sport'] ?? '',
      avatar: json['avatar'] ?? '',
      members: membersList,
    );
  }
}

class TeamProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Team? _currentTeam;
  List<String> _userSports = [];
  bool _isLoading = false;
  String? _error;

  Team? get currentTeam => _currentTeam;
  List<String> get userSports => _userSports;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch sports for current user
  Future<void> fetchUserSports() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      final teamsSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('teams')
          .get();

      if (teamsSnapshot.docs.isEmpty) {
        _error = "No sports found for this user.";
      } else {
        _userSports = teamsSnapshot.docs.map((doc) => doc.id).toList();
      }
    } catch (e) {
      _error = "Failed to fetch sports: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch team data for selected sport
  Future<void> fetchTeamData(String sport) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      // Get teamId for the selected sport
      final sportDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('teams')
          .doc(sport)
          .get();

      if (!sportDoc.exists) {
        _currentTeam = null;
        return;
      }

      String? teamId = sportDoc.data()?['teamId'];
      if (teamId == null) throw Exception("Team ID not found.");

      // Fetch team data
      final teamDoc = await _firestore.collection('teams').doc(teamId).get();

      if (!teamDoc.exists) {
        _currentTeam = null;
        return;
      }

      var teamData = teamDoc.data()!;
      teamData['teamId'] = teamId;
      teamData['sport'] = sport;

      _currentTeam = Team.fromJson(teamData);
    } catch (e) {
      _error = "Failed to fetch team data: $e";
      _currentTeam = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Invite player to team
  Future<void> invitePlayer(String playerId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");
      if (_currentTeam == null) throw Exception("No team selected");

      // Fetch player data
      final playerDoc =
          await _firestore.collection('users').doc(playerId).get();
      final currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!playerDoc.exists || !currentUserDoc.exists) {
        throw Exception("User not found");
      }

      final String senderName = currentUserDoc.data()?['firstName'] ?? "Sender";
      final String receiverName = playerDoc.data()?['firstName'] ?? "receiver";

      // Create invite
      await _firestore
          .collection('users')
          .doc(playerId)
          .collection('invites')
          .add({
        "avatar": _currentTeam!.avatar,
        "teamId": _currentTeam!.id,
        "teamName": _currentTeam!.name,
        "sport": _currentTeam!.sport,
        "from": senderName,
        "timestamp": Timestamp.now(),
        "status": "pending",
      });

      // Record sent invite
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('sentInvites')
          .add({
        "avatar": _currentTeam!.avatar,
        "teamId": _currentTeam!.id,
        "teamName": _currentTeam!.name,
        "sport": _currentTeam!.sport,
        "to": receiverName,
        "timestamp": Timestamp.now(),
        "status": "pending",
      });
    } catch (e) {
      _error = "Failed to send invite: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Leave team
  Future<void> leaveTeam() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");
      if (_currentTeam == null) throw Exception("No team selected");

      // Get user data
      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      final userName = userDoc.data()?['firstName'] ?? 'Unknown';

      // Update team members
      await _firestore.runTransaction((transaction) async {
        final teamRef = _firestore.collection('teams').doc(_currentTeam!.id);
        final teamDoc = await transaction.get(teamRef);

        if (!teamDoc.exists) throw Exception("Team not found");

        List<dynamic> members = List.from(teamDoc.data()?['members'] ?? []);
        members.removeWhere((member) => member['name'] == userName);

        transaction.update(teamRef, {'members': members});
      });

      // Remove team reference from user's teams
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('teams')
          .doc(_currentTeam!.sport)
          .delete();

      // Update local state
      _userSports.remove(_currentTeam!.sport);
      _currentTeam = null;
    } catch (e) {
      _error = "Failed to leave team: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
