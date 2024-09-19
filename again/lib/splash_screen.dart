import 'package:clone/features/authentication/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate a delay for the splash screen
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      body: Column(
        children: [
          // Spacer to push the first image to the middle of the screen
          const Spacer(flex: 2),

          // Middle image (center of the screen)
          Center(
            child: Image.asset(
              'assets/insta_logo.png',
              height: 50,
              width: 50,
            ),
          ),

          const Spacer(flex: 1), // Small space between the images and text

          // 'from' text and bottom image
          Column(
            children: [
              Text(
                'from',
                style: TextStyle(fontSize: 10), // Adjust font size as needed
              ),
              // const SizedBox(
              //     height: ), // Spacing between text and second image
              Image.asset(
                'assets/meta.png',
                height: 50,
                width: 50,
              ),
            ],
          ),

          // Spacer to push the bottom content to just above the bottom of the screen
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
