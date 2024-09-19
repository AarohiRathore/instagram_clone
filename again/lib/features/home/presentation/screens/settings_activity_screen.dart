import 'package:flutter/material.dart';

import '../../../authentication/presentation/screens/login_screen.dart';

class SettingsActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings and Activity'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row with leading text, image icon, and trailing text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Leading text
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Your account',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                // Image icon
                Padding(padding: const EdgeInsets.all(32), child: Text('')),
                // Trailing text (if any)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/meta.png', // Replace with your icon path
                    height: 60,
                    width: 60,
                  ), // Placeholder for trailing text
                ),
              ],
            ),
            SizedBox(height: 5), // Space between the row and the next section

            // Container to maintain the alignment for "Account Centre" and subsequent text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with Icon and "Account Centre"
                  Row(
                    children: [
                      // Icon at the start
                      Icon(Icons.person, size: 24),
                      SizedBox(width: 10), // Space between icon and text
                      Text(
                        'Account Centre',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          8), // Space between "Account Centre" and the next text

                  // Row with text and arrow icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text aligned with "Account Centre"
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 34.0), // Align with "Account Centre" text
                          child: Text(
                            'Password, Security, Personal Details, Ad Preferences',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      // Arrow icon
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Additional space or widgets if needed
            SizedBox(height: 50), // Adjust space as needed

            // Text section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Manage your connected experiences and account settings across Meta technologies',
                style: TextStyle(fontSize: 14),
              ),
            ),

            SizedBox(height: 16), // Space between sections

            // "How to use Instagram" section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'How to use Instagram',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
                height:
                    8), // Space between "How to use Instagram" and the following row

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 20),
                  Text('Saved'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.archive_outlined),
                  SizedBox(width: 20),
                  Text('Archived'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.local_activity),
                  SizedBox(width: 20),
                  Text('Your Activity'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.notifications_outlined),
                  SizedBox(width: 20),
                  Text('Notification'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.lock_clock),
                  SizedBox(width: 20),
                  Text('Time Management'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 16), // Space between sections

            // "Who can see your content" section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Who can see your content',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 20),
                  Text('Acount Privacy'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.star_border),
                  SizedBox(width: 20),
                  Text('Close friends'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.block),
                  SizedBox(width: 20),
                  Text('Block'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.hide_image),
                  SizedBox(width: 20),
                  Text('Hide story and live'),
                  Spacer(), // Pushes the icon to the far right
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            SizedBox(height: 16), // Space between sections

            // "Who can see your content" section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TextButton(onPressed: () {}, child: Text('Add account'))
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _showLogoutDialog(
                            context, false); // false for single account logout
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        _showLogoutDialog(
                            context, true); // true for logout from all accounts
                      },
                      child: Text(
                        'Log out of all accounts',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isLogoutAll) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text(
            'Log out ${isLogoutAll ? 'of all accounts' : 'of your account'}?',
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _logout(context, isLogoutAll);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context, bool isLogoutAll) async {
    // Clear user session (e.g., remove auth tokens, user data)
    // This may involve calling a method from a repository or clearing shared preferences

    // Example: Clear user session using a method from AuthCubit (if using Cubit/Bloc)
    // context.read<AuthCubit>().logout(); // Uncomment if using Cubit for auth
    // Optionally handle 'isLogoutAll' to manage logout from all accounts

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
