import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:intl/intl.dart';

class CreatePostScreen extends StatefulWidget {
  final List<XFile> selectedImages;

  CreatePostScreen({required this.selectedImages});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool uploading = false;
  double val = 0;
  late firebase_storage.Reference ref;
  final ImagePicker _picker = ImagePicker(); // Initialize the ImagePicker

  final descriptionController = TextEditingController();
  final locationController =
      TextEditingController(); // Removed default location
  final timestampController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now())); // Default timestamp
  String? uid; // UID is now a string

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserUid();
  }

  Future<void> _fetchCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser; // Get current user
    if (user != null) {
      setState(() {
        uid = user.uid; // Set UID to the current user's UID
      });
    }
  }

  Future<void> uploadFile(String uid) async {
    int i = 1;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    List<Map<String, dynamic>> newImageDetails =
        []; // List to store new image details

    // Upload new images and get download URLs along with other details
    for (var img in widget.selectedImages) {
      try {
        setState(() {
          val = i / widget.selectedImages.length;
        });
        ref = firebase_storage.FirebaseStorage.instance.ref().child(
            'images/${Path.basename(img.path)}'); // Firebase Storage reference

        String downloadUrl;

        if (kIsWeb) {
          await ref.putData(await img.readAsBytes()).whenComplete(() async {
            downloadUrl = await ref.getDownloadURL();
            newImageDetails.add({
              'url': downloadUrl,
              'description': descriptionController.text,
              'location': locationController.text,
              'timestamp': timestampController.text,
            });
            i++;
          });
        } else {
          await ref.putFile(File(img.path)).whenComplete(() async {
            downloadUrl = await ref.getDownloadURL();
            newImageDetails.add({
              'url': downloadUrl,
              'description': descriptionController.text,
              'location': locationController.text,
              'timestamp': timestampController.text,
            });
            i++;
          });
        }
      } catch (e) {
        print('Error uploading file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: $e'),
          ),
        );
      }
    }

    // Fetch existing image data from Firestore
    List<Map<String, dynamic>> existingImageDetails = [];
    try {
      DocumentSnapshot userDoc = await userRef.get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('images')) {
          existingImageDetails =
              List<Map<String, dynamic>>.from(data['images']);
        }
      }
    } catch (e) {
      print('Error fetching existing image data: $e');
    }

    // Combine existing image details with new image details
    List<Map<String, dynamic>> combinedImageDetails = [
      ...existingImageDetails,
      ...newImageDetails,
    ];

    // Update Firestore document with the combined list of image details
    try {
      await userRef.update({
        'images':
            combinedImageDetails, // Update with the combined list of image details
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Images uploaded successfully!'),
        ),
      );
      // Clear the fields
      setState(() {
        widget.selectedImages.clear();
        descriptionController.clear();
        locationController.clear(); // Clear location input
        timestampController.text = DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.now()); // Reset to current timestamp
      });
    } catch (e) {
      print('Error updating Firestore document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update Firestore document: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.selectedImages.isNotEmpty && !uploading)
            IconButton(
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                if (uid != null) {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile(uid!).whenComplete(() {
                    setState(() {
                      uploading = false;
                    });
                  }).catchError((error) {
                    setState(() {
                      uploading = false;
                    });
                    print('Failed to upload images: $error');
                  });
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                    itemCount: widget.selectedImages.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                              child: IconButton(
                                icon: Icon(Icons.add_a_photo),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: kIsWeb
                                      ? NetworkImage(
                                          widget.selectedImages[index - 1].path)
                                      : FileImage(File(widget
                                          .selectedImages[index - 1]
                                          .path)) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                    },
                  ),
                ),
                if (uploading)
                  Center(
                    child: CircularProgressIndicator(
                      value: val,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter description',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText:
                    'Enter location', // Now users can enter their location
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: timestampController,
              decoration: InputDecoration(
                hintText: 'Timestamp',
                enabled: false, // Make this field read-only
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> chooseImage() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        widget.selectedImages.addAll(pickedFiles);
      });
    }
  }
}
