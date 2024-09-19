import 'package:cached_network_image/cached_network_image.dart';
import 'package:clone/features/home/presentation/screens/create_post_screen.dart';
import 'package:clone/features/home/presentation/screens/settings_activity_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? user;
  Future<List<String>>? _imageUrlsFuture; // Future to track image loading
  bool _isImagesLoaded = false; // Track if images are loaded

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreatePostScreen(
                  selectedImages: [],
                )),
      );
    }
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if (_selectedIndex == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = _getImageUrls(); // Initialize the future
  }

  Future<List<String>> _getImageUrls() async {
    try {
      String uid = _auth.currentUser!.uid;

      // Fetch the user's document from Firestore
      DocumentSnapshot userSnap =
          await _firebaseFirestore.collection('users').doc(uid).get();
      final userData = userSnap.data() as Map<String, dynamic>;

      // Extract the 'images' field from the user document
      List<dynamic> imagesList = userData['images'] ?? [];

      // Extract URLs from the images list
      List<String> imageUrls = imagesList
          .map<String>((imageData) =>
              (imageData as Map<String, dynamic>)['url'] as String)
          .toList();

      // Set user data and update state
      setState(() {
        user = UserModel.fromDocumentSnapshot(userSnap, imageUrls.length);
        _isImagesLoaded = true;
      });

      return imageUrls;
    } catch (e) {
      print('Error fetching image URLs: $e');
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.only(top: 40.0), // Add space from the top
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUsernameAndIcons(context),
                      SizedBox(height: 16),
                      _buildProfileHeader(),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 16),
                      _isImagesLoaded
                          ? FutureBuilder<List<String>>(
                              future: _imageUrlsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  // Show error message if there's an error
                                  return Center(
                                      child: Text('Error loading images'));
                                } else if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  // Show image grid if images are available
                                  List<String> imageUrls = snapshot.data!;
                                  return _buildImageGrid(imageUrls);
                                } else {
                                  // Show a message if no images are available
                                  return Center(
                                      child: Text('No posts available'));
                                }
                              },
                            )
                          : Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/instagram-reels-icon.png',
                height: 20,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: user?.profileImageUrl.isNotEmpty ?? false
                    ? NetworkImage(user!.profileImageUrl)
                    : AssetImage('assets/default-avatar.png') as ImageProvider,
                radius: 12, // Adjust size as needed
              ),
              label: '',
            ),
          ],
        ));
  }

  Widget _buildUsernameAndIcons(BuildContext context) {
    return Row(
      children: [
        Text(
          user?.name ?? '', // Safely access user data
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Image.asset('assets/@.png', height: 25, width: 30),
          onPressed: () {
            // Add functionality for edit icon
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_box_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePostScreen(
                        selectedImages: [],
                      )),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsActivityScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.profileImageUrl.isNotEmpty ?? false
                  ? NetworkImage(user!.profileImageUrl)
                  : null,
              child: user?.profileImageUrl.isEmpty ?? true
                  ? const Icon(Icons.person, size: 50)
                  : null,
              backgroundColor: Colors.grey[200],
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Posts', user?.postsCount ?? 0),
              _buildStatColumn('Followers', user?.followersCount ?? 0),
              _buildStatColumn('Following', user?.followingCount ?? 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildImageGrid(List<String> imageUrls) {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 images per row
          crossAxisSpacing: 4, // Space between the columns
          mainAxisSpacing: 4, // Space between the rows
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.white, width: 1.0), // Add border
                borderRadius:
                    BorderRadius.circular(8), // Optional: rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    8), // Clip image within the border radius
                child: CachedImage(imageUrls[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
            flex: 2, // Allocate more space to this button
            child: TextButton(
              onPressed: () {
                // Add functionality for button
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor:
                    const Color.fromARGB(37, 158, 158, 158), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(6), // Set the desired border radius
                ),
              ),
              child: Text('Edit profile'),
            )),
        const SizedBox(width: 12), // Space between buttons
        Expanded(
          flex: 2, // Allocate more space to this button
          child: TextButton(
            onPressed: () {
              // Add functionality for button 2
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor:
                  const Color.fromARGB(37, 158, 158, 158), // Background color
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(6), // Set the desired border radius
              ),
            ),
            child: const Text('share profile'),
          ),
        ),
        TextButton(
            onPressed: () {},
            child: IconButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(37, 158, 158, 158),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        6), // Set the desired border radius
                  ),
                ),
                icon: Image.asset(
                  'assets/add-contact.png',
                  width: 20,
                  height: 20,
                )))
      ],
    );
  }
}

class UserModel {
  final String profileImageUrl;
  final String name;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  UserModel({
    required this.profileImageUrl,
    required this.name,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc, int postsCount) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      profileImageUrl: data['profileImageUrl'] ?? '',
      name: data['name'] ?? '',
      postsCount: postsCount,
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
    );
  }
}

class CachedImage extends StatelessWidget {
  final String imageUrl;

  const CachedImage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover, // Adjust fit as needed
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
