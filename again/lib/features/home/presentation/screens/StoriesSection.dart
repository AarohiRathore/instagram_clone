import 'package:clone/features/home/domain/story.dart';
import 'package:clone/features/home/presentation/screens/StoryDetailScreen.dart';
import 'package:flutter/material.dart';

class StoriesSection extends StatelessWidget {
  final List<Story> stories;

  const StoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust based on the desired height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDetailScreen(story: story),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30, // Adjust the radius
                    backgroundImage: NetworkImage(story.avatarUrl),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    story.username,
                    style: const TextStyle(fontSize: 12), // Adjust text size
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
