import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signup(
      String name, String email, String password, String bio) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid =
          userCredential.user!.uid; // Auto-generated UID from FirebaseAuth

      // Store additional user information in Firestore
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'uid': uid, // Store auto-generated UID
        'password':
            password, // Be cautious about storing passwords; consider using Firebase Authentication's secure mechanisms
        'bio': bio, // Save bio
      });

      return uid;
    } catch (e) {
      throw Exception('Failed to sign up user: ${e.toString()}');
    }
  }
}
