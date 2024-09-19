import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStoreDataBase {
  String? downloadURL;

  Future<String?> getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    try {
      // Replace '' with the actual path to your file in Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('33.PNG');
      downloadURL = await ref.getDownloadURL();
      debugPrint('Download URL: $downloadURL');
    } catch (e) {
      debugPrint("Error fetching download URL: $e");
    }
  }
}
