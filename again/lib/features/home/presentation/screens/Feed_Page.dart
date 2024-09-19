import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageDisplayScreen extends StatefulWidget {
  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  List<QueryDocumentSnapshot> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;
  final int _limit = 10; // Number of documents to fetch per request

  @override
  void initState() {
    super.initState();
    _fetchUsers();

    // Add scroll listener to detect when reaching the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchUsers();
      }
    });
  }

  Future<void> _fetchUsers() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Query query =
          _firestore.collection('users').orderBy('name').limit(_limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _hasMore = snapshot.docs.length == _limit;
        _users.addAll(snapshot.docs);
      } else {
        _hasMore = false;
      }

      setState(() {});
    } catch (e) {
      // Handle error
      print('Error fetching users: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _users.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _users.length) {
            // Show a loading indicator while fetching more data
            return Center(child: CircularProgressIndicator());
          }

          final doc = _users[index];
          final imageData = doc.data() as Map<String, dynamic>;

          // Extract image URLs from the 'images' field
          final List<dynamic> imagesList = imageData['images'] ?? [];
          final imageUrls = imagesList
              .map<String>((imageData) =>
                  (imageData as Map<String, dynamic>)['url'] as String)
              .toList();

          final username = imageData['name'] as String?;
          final description = imageData['description'] as String?;
          final profileImageUrl = imageData['profileImageUrl'] as String?;

          if (imageUrls.isEmpty) {
            return SizedBox.shrink(); // No image to show, don't render
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: CircleAvatar(
                  backgroundImage:
                      profileImageUrl != null && profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                  child: profileImageUrl == null || profileImageUrl.isEmpty
                      ? Text(
                          username != null && username.isNotEmpty
                              ? username[0]
                              : '?',
                        )
                      : null,
                ),
                title: Text(
                  username ?? 'No Username',
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    print('Follow button pressed for $username');
                  },
                  child: Text(
                    'Follow',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color.fromARGB(107, 158, 158, 158), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          4.0), // Adjust the border radius here
                    ),
                  ),
                ),
              ),

              // Display carousel for multiple images
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: false,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false, // Stop looping
                ),
                items: imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              // StreamBuilder for dynamic like count and state update
              StreamBuilder<DocumentSnapshot>(
                stream: _firestore.collection('users').doc(doc.id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Document does not exist');
                  }

                  final updatedData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  int likeCount = updatedData['likeCount'] as int? ?? 0;
                  final likedBy = updatedData['likedBy'] as List<dynamic>?;
                  final userId = _auth.currentUser?.uid;
                  bool isLiked = likedBy != null && likedBy.contains(userId);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              IconButton(
                                iconSize: 24.0,
                                padding: EdgeInsets.all(8.0),
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.black54,
                                ),
                                onPressed: () {
                                  if (isLiked) {
                                    _firestore
                                        .collection('users')
                                        .doc(doc.id)
                                        .update({
                                      'likeCount':
                                          likeCount > 0 ? likeCount - 1 : 0,
                                      'likedBy':
                                          FieldValue.arrayRemove([userId]),
                                    });
                                  } else {
                                    _firestore
                                        .collection('users')
                                        .doc(doc.id)
                                        .update({
                                      'likeCount': likeCount + 1,
                                      'likedBy':
                                          FieldValue.arrayUnion([userId]),
                                    });
                                  }
                                },
                              ),
                              Text(
                                '$likeCount',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.black54),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/msg.png',
                                    height: 30,
                                    width: 30,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    'assets/send.jpg',
                                    height: 25,
                                    width: 20,
                                  ))
                            ],
                          ),
                        ),
                        IconButton(
                          iconSize: 24.0,
                          padding: EdgeInsets.all(8.0),
                          icon: Image.asset(
                            'assets/save.png',
                            height: 25,
                            width: 20,
                          ),
                          onPressed: () {
                            print('Save button pressed');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
