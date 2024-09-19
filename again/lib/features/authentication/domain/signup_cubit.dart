import 'dart:io'; // For mobile
import 'package:clone/features/authentication/data/user_repository.dart';
import 'package:clone/features/authentication/domain/signup_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // For mobile

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(UserRepository userRepository) : super(SignupInitial());

  File? profileImage; // For mobile
  final picker = ImagePicker();

  Future<void> pickImage() async {
    if (!kIsWeb) {
      // Handle image picking for mobile
      try {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          profileImage = File(pickedFile.path);
          emit(SignupImagePickedSuccess());
        } else {
          emit(SignupImagePickedFailure('No image selected'));
        }
      } catch (e) {
        emit(SignupImagePickedFailure('Failed to pick image: ${e.toString()}'));
      }
    }
  }

  Future<void> signup(String name, String email, String password,
      String confirmPassword, String bio) async {
    if (password != confirmPassword) {
      emit(SignupFailure('Passwords do not match'));
      return;
    }

    emit(SignupLoading());

    try {
      // Create the user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Upload profile image if exists
        String? imageUrl;
        if (profileImage != null) {
          imageUrl = await uploadProfileImage(user.uid, profileImage!);
        }

        // Save user details to Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'profileImageUrl': imageUrl ?? '',
          'bio': bio, // Save bio
        });

        emit(SignupSuccess(user.uid));
      }
    } catch (e) {
      emit(SignupFailure('Failed to sign up: ${e.toString()}'));
    }
  }

  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profileImages/$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }
}
