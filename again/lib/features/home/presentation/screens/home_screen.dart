import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/story.dart';
import 'Feed_Page.dart';
import 'StoriesSection.dart';
import 'create_post_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Usermodel? user;
  final List<Story> stories = [
    Story(
        username: 'User 1',
        avatarUrl: 'assets/pic1.jpg',
        storyContentUrl: 'assets/pic1.jpg'),
    Story(
        username: 'User 2',
        avatarUrl: 'assets/pic2.jpg',
        storyContentUrl: 'assets/pic2.jpg'),
    Story(
        username: 'User 3',
        avatarUrl: 'assets/pic3.jpg',
        storyContentUrl: 'assets/pic3.jpg'),
    Story(
        username: 'User 4',
        avatarUrl: 'assets/pic4.jpg',
        storyContentUrl: 'assets/pic4.jpg'),
    Story(
        username: 'User 5',
        avatarUrl: 'assets/pic5.jpg',
        storyContentUrl: 'assets/pic5.jpg'),
    Story(
        username: 'User 6',
        avatarUrl: 'assets/pic6.jpg',
        storyContentUrl: 'assets/pic6.jpg'),
    Story(
        username: 'User 7',
        avatarUrl: 'assets/pic7.jpg',
        storyContentUrl: 'assets/pic7.jpg'),
    Story(
        username: 'User 8',
        avatarUrl: 'assets/pic8.jpg',
        storyContentUrl: 'assets/pic8.jpg'),
    Story(
        username: 'User 9',
        avatarUrl: 'assets/pic9.jpg',
        storyContentUrl: 'assets/pic9.jpg'),
    Story(
        username: 'User 10',
        avatarUrl: 'assets/pic10.jpg',
        storyContentUrl: 'assets/pic10.jpg'),
  ];

  final ImagePicker _picker = ImagePicker();

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 2) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostScreen(selectedImages: pickedFiles),
          ),
        );
      }
    } else if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (_selectedIndex == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            // SliverAppBar to scroll up first
            SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              leading:
                  Image.asset('assets/instagram.jpg', height: 50, width: 50),
              actions: [
                const Icon(Icons.favorite_border_outlined,
                    color: Colors.black, size: 25),
                SizedBox(width: 25),
                Image.asset('assets/message.jpg'),
              ],
              // floating: true, // Makes the AppBar float above content
              // pinned: false, // Does not pin the AppBar, allowing it to scroll up
              // snap:
              //     true, // Allows the AppBar to snap back into view when scrolled up
            ),
            // Sliver for Stories section
            SliverToBoxAdapter(
              child: Container(
                height: 100,
                color: Colors.white,
                child: StoriesSection(stories: stories),
              ),
            ),
            // Sliver for remaining content
            SliverFillRemaining(
              child: ImageDisplayScreen(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          showSelectedLabels: false, // Optionally hide labels
          showUnselectedLabels: false, // Optionally hide labels

          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == 0 ? 'assets/home2.png' : 'assets/home1.png',
                width: 24, // Adjust size if needed
                height: 24, // Adjust size if needed
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == 0
                    ? 'assets/search1.png'
                    : 'assets/search2.png',
                width: 24, // Adjust size if needed
                height: 24, // Adjust size if needed
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _selectedIndex == 0 ? 'assets/reel1.png' : 'assets/reel2.png',
                width: 24, // Adjust size if needed
                height: 24, // Adjust size if needed
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundImage: user?.profile.isNotEmpty ?? false
                    ? NetworkImage(user!.profile)
                    : const AssetImage('assets/default-avatar.png')
                        as ImageProvider,
                radius: 12, // Adjust size as needed
              ),
              label: '',
            ),
          ],
        ));
  }
}

class Usermodel {
  final String username;
  final String profile; // Ensure this is the URL for the profile image
  final String bio; // Add this line
  final List followers;
  final List following;

  Usermodel({
    required this.username,
    required this.profile, // Ensure this is the URL for the profile image
    required this.bio, // Add this line
    required this.followers,
    required this.following,
  });

  factory Usermodel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usermodel(
      username: data['username'] ?? '',
      profile:
          data['profile'] ?? '', // Ensure this is the URL for the profile image
      bio: data['bio'] ?? '', // Ensure bio is included
      followers: data['followers'] ?? [],
      following: data['following'] ?? [],
    );
  }
}
