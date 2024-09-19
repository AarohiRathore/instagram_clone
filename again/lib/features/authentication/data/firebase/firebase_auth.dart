import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirm,
    required String username,
    required String bio,
    required File profile,
  }) async {
    try {
      // Check if all fields are not empty
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty) {
        // Check if password matches the confirmation
        if (password == passwordConfirm) {
          // Create a new user with email and password
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          // Additional logic for uploading profile image, saving bio, etc.
        } else {
          throw Exception('Password and confirm password should be the same.');
        }
      } else {
        throw Exception('Please fill in all the fields.');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message.toString());
    }
  }
}
