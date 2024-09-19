import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseOperations {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> downloadUrls = [];

    for (File image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('posts/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  Future<void> storePost(String uid, List<String> imageUrls) async {
    await _firestore.collection('posts').add({
      'userId': uid,
      'imageUrls': imageUrls,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
