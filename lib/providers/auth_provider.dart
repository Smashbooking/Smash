// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'auth_state.dart';

// part 'auth_provider.g.dart';

// @riverpod
// class AuthNotifier extends _$AuthNotifier {
//   @override
//   AuthState build() {
//     return const AuthState();
//   }

//   Future<void> signUp({
//     required String email,
//     required String password,
//     required String phoneNumber,
//   }) async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final auth = FirebaseAuth.instance;
//       final firestore = FirebaseFirestore.instance;

//       // Create Firebase user
//       final UserCredential userCredential =
//           await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Store user data in Firestore
//       await firestore.collection('users').doc(userCredential.user?.uid).set({
//         "email": email,
//         "phoneNumber": phoneNumber,
//         "isAdmin": false,
//       });

//       state = state.copyWith(
//         isLoading: false,
//         isAuthenticated: true,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: e.toString(),
//       );
//     }
//   }

//   // Add login method to existing provider
//   Future<void> login({
//     required String email,
//     required String password,
//   }) async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final auth = FirebaseAuth.instance;
//       final firestore = FirebaseFirestore.instance;

//       // Authenticate user
//       final UserCredential userCredential =
//           await auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Fetch user data from Firestore
//       final userDoc = await firestore
//           .collection('users')
//           .doc(userCredential.user?.uid)
//           .get();

//       if (userDoc.exists) {
//         state = state.copyWith(
//           isLoading: false,
//           isAuthenticated: true,
//         );
//       } else {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: "User not registered. Please sign up.",
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: e.toString(),
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/validation_utils.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final String _authStateKey = 'auth_state';

  @override
  AuthState build() {
    _initializeAuthState();
    return const AuthState();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // Create Firebase user
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        "email": email,
        "phoneNumber": phoneNumber,
        "isAdmin": false,
      });

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Add login method to existing provider
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;

      // Authenticate user
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (userDoc.exists) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "User not registered. Please sign up.",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Initialize auth state from persistence
  Future<void> _initializeAuthState() async {
    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      final userData = await _fetchUserData(currentUser.uid);
      state = state.copyWith(
        isAuthenticated: true,
        user: currentUser,
        userData: userData,
        isEmailVerified: currentUser.emailVerified,
      );
    }

    // Listen to auth state changes
    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        state = const AuthState();
      } else {
        final userData = await _fetchUserData(user.uid);
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          userData: userData,
          isEmailVerified: user.emailVerified,
        );
      }
    });
  }

  Future<Map<String, dynamic>?> _fetchUserData(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data();
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    final emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) {
      state = state.copyWith(errorMessage: emailError);
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Password reset email sent. Please check your inbox.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableAuthError(e),
      );
    }
  }

  // Logout functionality
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await FirebaseAuth.instance.signOut();
      await _persistAuthState(false);
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _getReadableAuthError(e),
      );
    }
  }

  // Persist auth state
  Future<void> _persistAuthState(bool isAuthenticated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authStateKey, isAuthenticated);
  }

  // Helper to convert Firebase errors to readable messages
  String _getReadableAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email';
        case 'wrong-password':
          return 'Invalid password';
        case 'email-already-in-use':
          return 'Email is already registered';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-disabled':
          return 'This account has been disabled';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return error.toString();
  }
}
