import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ImageRepository(FirebaseStorage instance);

  Future<String> getImageUrl(int uid) async {
    try {
      // Query by the uid field instead of using it as a document ID
      QuerySnapshot query = await _firestore
          .collection('user_images')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return query.docs.first['imageUrl']; // Make sure this field exists
      } else {
        throw Exception('Image not found');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}
